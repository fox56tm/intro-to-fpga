import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge
import random

class HelperPairwise:

    def __init__(self, dut):
        self.dut = dut
        self.prev_bit = None
        self.expected = []

    async def generate_rnd_input(self):
        while True:
            self.dut.s_valid.value = random.randint(0,1)
            self.dut.s_data.value = random.randint(0,1)
            self.dut.m_ready.value = random.randint(0,1)
            await RisingEdge(self.dut.clk)

    async def initialize_rst(self):
        self.dut.aresetn.value = 0
        await ClockCycles(self.dut.clk, 2)
        self.dut.aresetn.value = 1

    async def setup(self):
        self.dut.s_valid.value = 0
        self.dut.s_data.value = 0
        self.dut.m_ready.value = 0
    
    async def my_pairwise(self):
        while True:
            await RisingEdge(self.dut.clk)
            if self.dut.s_valid.value == 1 and self.dut.s_ready.value == 1:
                current_bit = int(self.dut.s_data.value)
                if self.prev_bit is not None:
                    pair = (self.prev_bit << 1) | current_bit
                    self.expected.append(pair)
                self.prev_bit = current_bit

    async def check_output(self):
        while True:
            await RisingEdge(self.dut.clk)
            if self.dut.m_valid.value == 1 and self.dut.m_ready.value == 1:
                assert len(self.expected) > 0, "Incorrect flag logic"
                expected_val = self.expected.pop(0)
                actual = self.dut.m_data.value.integer
                assert actual == expected_val, f"Error! Got: {actual}, Expected: {expected_val}"

@cocotb.test()
async def run_pairwise_test(dut):
    clock = Clock(dut.clk, 10, units="ns")
    helper = HelperPairwise(dut)
    cocotb.start_soon(clock.start(start_high=False))

    helper.setup()
    await helper.initialize_rst()

    cocotb.start_soon(helper.generate_rnd_input())
    cocotb.start_soon(helper.my_pairwise())
    cocotb.start_soon(helper.check_output())

    await ClockCycles(dut.clk, 1000)
