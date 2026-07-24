import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge
from cocotb.regression import TestFactory
import random

class HelperLineBuffer:

    def __init__(self, dut, m, image_str_len):
        self.dut = dut
        self.m = m
        self.image_str_len = image_str_len
        self.buffer = [[0 for _ in range(self.image_str_len)] for _ in range(self.m + 1)]

    async def initialize_rst(self):
        self.dut.aresetn.value = 0
        await ClockCycles(self.dut.clk, 2)
        self.dut.aresetn.value = 1

    def setup(self):
        self.dut.sel.value = 0
        self.dut.s_data.value = 0
        self.dut.s_valid.value = 0
        self.dut.m_ready.value = 0

    async def my_in_line_buffer(self):
        while True:
            await RisingEdge(self.dut.clk)
            if self.dut.s_valid.value and self.dut.s_ready.value:
                sel_used = self.dut.sel.value.to_unsigned()
                row = self.buffer[sel_used]
                self.buffer[sel_used] = row[1:] + [self.dut.s_data.value.to_unsigned()]

    async def check_output(self):
        while True:
            await RisingEdge(self.dut.clk)
            if self.dut.m_valid.value and self.dut.m_ready.value:
                sel_now = self.dut.sel.value.to_unsigned()
                for i in range(0, self.m):
                    row = self.buffer[(sel_now + i + 1) % (self.m + 1)]
                    for j in range(0, self.image_str_len):
                        idx = i * self.image_str_len + j
                        actual = self.dut.to_conv1d[idx].value.to_unsigned()
                        assert row[j] == actual, (
                            f"Lane {i} pos {j}: Got {actual}, Expected {row[j]}"
                        )

    async def generate_rnd_iput(self):
        while True:
            await RisingEdge(self.dut.clk)
            self.dut.sel.value = int(self.dut.str_cnt.value)
            self.dut.s_data.value = random.randint(0, 255)
            self.dut.s_valid.value = random.randint(0, 1)
            self.dut.m_ready.value = random.randint(0, 1)

async def run_in_line_buffer_test(dut, m, image_str_len):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    helper = HelperLineBuffer(dut, m, image_str_len)

    helper.setup()
    await helper.initialize_rst()

    cocotb.start_soon(helper.my_in_line_buffer())
    cocotb.start_soon(helper.check_output())
    cocotb.start_soon(helper.generate_rnd_iput())
    await ClockCycles(dut.clk, 1000)

factory = TestFactory(test_function=run_in_line_buffer_test)
factory.add_option("m", [3])
factory.add_option("image_str_len", [20])
factory.generate_tests()
