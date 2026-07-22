import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge
from cocotb.regression import TestFactory
import random

class HelperWindowed:
    def __init__(self, dut, win_size):
        self.dut = dut
        self.win_size = win_size
        self.history = []
        self.expected = []

    async def generate_rnd_input(self):
        while True:
            self.dut.s_valid.value = random.randint(0, 1)
            self.dut.s_data.value = random.randint(0, 1)
            self.dut.m_ready.value = random.randint(0, 1)
            await RisingEdge(self.dut.clk)

    async def initialize_rst(self):
        self.dut.aresetn.value = 0
        await ClockCycles(self.dut.clk, 2)
        self.dut.aresetn.value = 1

    def setup(self):
        self.dut.s_valid.value = 0
        self.dut.s_data.value = 0
        self.dut.m_ready.value = 0
    
    async def my_windowed(self):
        while True:
            await RisingEdge(self.dut.clk)
            if self.dut.s_valid.value == 1 and self.dut.s_ready.value == 1:
                current_bit = int(self.dut.s_data.value)
                self.history.append(current_bit)
                if len(self.history) >= self.win_size:
                    window = self.history[-self.win_size:]
                    expected_val = 0
                    for bit in window:
                        expected_val = (expected_val << 1) | bit
                    self.expected.append(expected_val)

    async def check_output(self):
        while True:
            await RisingEdge(self.dut.clk)
            if self.dut.m_valid.value == 1 and self.dut.m_ready.value == 1:
                assert len(self.expected) > 0, "Incorrect flag logic"
                expected_val = self.expected.pop(0)
                actual = self.dut.m_data.value.integer
                assert actual == expected_val, f"Error! Got: {actual}, Expected: {expected_val}"


async def run_windowed_test(dut, win_size):
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    helper = HelperWindowed(dut, win_size)

    helper.setup()
    await helper.initialize_rst()
    await RisingEdge(dut.clk)

    cocotb.start_soon(helper.generate_rnd_input())
    cocotb.start_soon(helper.my_windowed())
    cocotb.start_soon(helper.check_output())
    await ClockCycles(dut.clk,1000)

factory = TestFactory(test_function=run_windowed_test)
factory.add_option("win_size", [8])
factory.generate_tests()
