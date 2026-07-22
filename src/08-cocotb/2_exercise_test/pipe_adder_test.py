import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, FallingEdge
import random
from cocotb.regression import TestFactory

class HelperPipeAdder:

    def __init__(self, dut):
        self.dut = dut
        self.carry = 0
        self.exp_vals = []

    async def initialize_rst(self):
        self.dut.aresetn.value = 0
        await ClockCycles(self.dut.clk, 2)
        self.dut.aresetn.value = 1

    def setup(self):
        self.dut.s_valid_1.value = 0
        self.dut.s_data_1.value = 0
        self.dut.s_valid_2.value = 0
        self.dut.s_data_2.value = 0
        self.dut.m_ready.value = 0

    def generate_rnd_input(self):
        self.dut.s_valid_1.value = random.randint(0,1)
        self.dut.s_data_1.value = random.randint(0,1)

        self.dut.s_valid_2.value = random.randint(0,1)
        self.dut.s_data_2.value = random.randint(0,1)

        self.dut.m_ready.value = random.randint(0,1)

    def my_pipe_adder(self):
        v1 = int(self.dut.s_valid_1.value)
        r1 = int(self.dut.s_ready_1.value)
        v2 = int(self.dut.s_valid_2.value)
        r2 = int(self.dut.s_ready_2.value)

        if (v1 and r1) and (v2 and r2):
            d1 = int(self.dut.s_data_1.value)
            d2 = int(self.dut.s_data_2.value)
            
            total = d1 + d2 + self.carry
            self.carry = total // 2
            bit_out = total % 2
            self.exp_vals.append(bit_out)
        elif not v1 and not v2:
            self.carry = 0

async def run_pipe_adder_test(dut, Iter):
    clock = Clock(dut.clk, 10, units="ns")
    helper = HelperPipeAdder(dut)
    cocotb.start_soon(clock.start(start_high=False))
    
    helper.setup()
    await helper.initialize_rst()

    for _ in range(Iter):
        await FallingEdge(dut.clk)
        helper.generate_rnd_input()
        await RisingEdge(dut.clk)
        helper.my_pipe_adder()

        if dut.m_valid.value and dut.m_ready.value:
            expected = helper.exp_vals.pop(0)
            assert dut.m_data.value == expected, f"ERROR {dut.m_data.value}, expec: {expected}"
        
factory = TestFactory(test_function=run_pipe_adder_test)
factory.add_option("Iter", [1000])
factory.generate_tests()
