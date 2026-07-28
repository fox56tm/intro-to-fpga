import random
import struct

import cocotb
from cocotb.clock import Clock
from cocotb.regression import TestFactory
from cocotb.triggers import ClockCycles, FallingEdge, ReadOnly, RisingEdge


def float_to_uint32(val: float) -> int:
    return struct.unpack("<I", struct.pack("<f", val))[0]


def uint32_to_float(val: int) -> float:
    return struct.unpack("<f", struct.pack("<I", val))[0]


WINDOW_OFFSET = 1
COUNT_REDUCTION = 2


class HelperImageConv:
    def __init__(self, dut, m, kernel_size, image_str_len):
        self.dut = dut
        self.m = m
        self.kernel_size = kernel_size
        self.image_str_len = image_str_len
        self.out_str_len = image_str_len - kernel_size + 1 - COUNT_REDUCTION
        self.weights_raw = [random.uniform(1.0, 5.0) for _ in range(kernel_size)]
        self.weights = [uint32_to_float(float_to_uint32(w)) for w in self.weights_raw]
        self.input_image = [
            [random.randint(0, 255) for _ in range(image_str_len)] for _ in range(m)
        ]
        self.expected = self.compute_expected()

    def compute_expected(self):
        expected = []
        for col in range(self.out_str_len):
            start = col + WINDOW_OFFSET
            total = 0
            for row in range(self.m):
                window = self.input_image[row][start : start + self.kernel_size]
                row_sum = sum(
                    min(int(w * b), 255) for w, b in zip(self.weights, window)
                )
                total += min(row_sum, 255)
            expected.append(min(total, 255))
        return expected

    async def initialize_rst(self):
        self.dut.aresetn.value = 0
        await ClockCycles(self.dut.clk, 2)
        self.dut.aresetn.value = 1

    def setup(self):
        self.dut.s_data.value = 0
        self.dut.sel.value = 0
        self.dut.s_valid.value = 0
        self.dut.w_valid.value = 0
        self.dut.weight_in.value = float_to_uint32(0.0)
        self.dut.m_ready.value = 0

    async def wait_until_accepted(self, valid_signal, ready_signal):
        while True:
            await ReadOnly()
            accepted = bool(valid_signal.value) and bool(ready_signal.value)
            await RisingEdge(self.dut.clk)
            if accepted:
                return

    async def load_weights(self):
        for w in self.weights_raw:
            self.dut.w_valid.value = 1
            self.dut.weight_in.value = float_to_uint32(w)
            await self.wait_until_accepted(self.dut.w_valid, self.dut.w_ready)
            await FallingEdge(self.dut.clk)
        self.dut.w_valid.value = 0

    async def generate_rnd_input(self):
        for row in range(self.m):
            for col in range(self.image_str_len):
                self.dut.sel.value = row
                self.dut.s_data.value = self.input_image[row][col]
                self.dut.s_valid.value = 1
                self.dut.m_ready.value = random.randint(0, 1)
                await self.wait_until_accepted(self.dut.s_valid, self.dut.s_ready)
                await FallingEdge(self.dut.clk)
        self.dut.s_valid.value = 0
        self.dut.m_ready.value = 1
        self.dut.sel.value = int(self.dut.buffer.str_cnt.value)

    async def check_output(self):
        for expected in self.expected:
            while True:
                await RisingEdge(self.dut.clk)
                await ReadOnly()
                if self.dut.m_valid.value and self.dut.m_ready.value:
                    break
            actual = self.dut.m_data.value.to_unsigned()
            assert actual == expected, f"Got {actual}, Expected {expected}"


async def run_image_conv_test(dut, m, kernel_size, image_str_len):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    helper = HelperImageConv(dut, m, kernel_size, image_str_len)

    helper.setup()
    await helper.initialize_rst()
    await helper.load_weights()
    cocotb.start_soon(helper.check_output())
    cocotb.start_soon(helper.generate_rnd_input())

    await ClockCycles(dut.clk, 1000)


factory = TestFactory(test_function=run_image_conv_test)
factory.add_option("m", [3])
factory.add_option("kernel_size", [3])
factory.add_option("image_str_len", [20])
factory.generate_tests()
