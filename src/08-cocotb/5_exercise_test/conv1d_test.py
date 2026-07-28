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


class HelperConv1d:
    def __init__(self, dut, kernel_size):
        self.dut = dut
        self.kernel_size = kernel_size

    async def initialize_rst(self):
        self.dut.aresetn.value = 0
        await ClockCycles(self.dut.clk, 2)
        self.dut.aresetn.value = 1

    def setup(self):
        self.dut.s_valid.value = 0
        self.dut.s_data.value = 0
        self.dut.m_ready.value = 0
        self.dut.weight_in.value = float_to_uint32(0.0)
        self.dut.w_valid.value = 0

    async def check_output(self):
        while True:
            await RisingEdge(self.dut.clk)
            await ReadOnly()
            if self.dut.m_valid.value == 1 and self.dut.m_ready.value == 1:
                weights = [
                    uint32_to_float(int(self.dut.weights_in_ker[i].value))
                    for i in range(self.kernel_size)
                ]
                bytes_ = [
                    int(self.dut.bytes_arr[i].value) for i in range(self.kernel_size)
                ]

                total = 0
                for i in range(self.kernel_size):
                    prod = weights[i] * bytes_[i]
                    total += min(int(prod), 255)
                expected_val = min(total, 255)

                actual = self.dut.m_data.value.to_unsigned()
                assert actual == expected_val, (
                    f"Error! Got: {actual}, Expected: {expected_val}"
                )

    async def generate_rnd_iput(self):
        while True:
            await RisingEdge(self.dut.clk)
            await FallingEdge(self.dut.clk)
            self.dut.weight_in.value = float_to_uint32(random.uniform(1.0, 5.0))
            self.dut.w_valid.value = random.randint(0, 1)
            self.dut.s_data.value = random.randint(0, 1)
            self.dut.s_valid.value = random.randint(0, 1)
            self.dut.m_ready.value = random.randint(0, 1)


async def run_conv1d_test(dut, kernel_size):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    helper = HelperConv1d(dut, kernel_size)

    helper.setup()
    await helper.initialize_rst()
    await RisingEdge(dut.clk)

    cocotb.start_soon(helper.check_output())
    cocotb.start_soon(helper.generate_rnd_iput())
    await ClockCycles(dut.clk, 1000)


factory = TestFactory(test_function=run_conv1d_test)
factory.add_option("kernel_size", [3])
factory.generate_tests()
