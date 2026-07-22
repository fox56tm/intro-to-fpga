import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge
import random
from cocotb.regression import TestFactory

class HelperMergeParallel:

    def __init__(self, dut, in_width_1, in_width_2):
        self.dut = dut
        self.InWidth1 = in_width_1
        self.InWidth2 = in_width_2
        self.OutWidth = self.InWidth1 + self.InWidth2
        self.res = 0

    async def generate_rnd_input(self):
        self.dut.s_valid_1.value = random.randint(0,1)
        self.dut.s_data_1.value = random.randint(0,(2**self.InWidth1)-1)

        self.dut.s_valid_2.value = random.randint(0,1)
        self.dut.s_data_2.value = random.randint(0,(2**self.InWidth2)-1)

        self.dut.m_ready.value = random.randint(0,1)
        await RisingEdge(self.dut.clk)

    async def initialize_rst(self):
        self.dut.aresetn.value = 0
        await ClockCycles(self.dut.clk, 2)
        self.dut.aresetn.value = 1

    async def setup(self):
        self.dut.s_valid_1.value = 0
        self.dut.s_valid_2.value = 0
        self.dut.m_ready.value = random.randint(0,1)
        self.dut.s_data_1.value = random.randint(0, (2**self.InWidth1)-1)
        self.dut.s_data_2.value = random.randint(0, (2**self.InWidth2)-1)
    
    async def my_merge_parallel(self):
        data1 = int(self.dut.s_data_1.value) if (self.dut.s_valid_1.value and self.dut.s_ready_1.value) else 0
        data2 = int(self.dut.s_data_2.value) if (self.dut.s_valid_2.value and self.dut.s_ready_2.value) else 0
        self.res = (data2 << self.InWidth1) | data1

async def run_merge_parallel_test(dut, Iter, in_width_1, in_width_2):
    clock = Clock(dut.clk, 10, units="ns")
    helper = HelperMergeParallel(dut, in_width_1, in_width_2)
    cocotb.start_soon(clock.start(start_high=False))

    helper.setup()
    helper.initialize_rst()
    await RisingEdge(dut.clk)

    for _ in range(Iter):
        helper.generate_rnd_input()
        helper.my_merge_parallel()
        
        if dut.m_valid.value ==1 and dut.m_ready.value ==1:
            assert helper.res == dut.m_data.value.integer, f"ERROR {dut.m_data.value.integer}, expec: {helper.res}" 

factory = TestFactory(test_function=run_merge_parallel_test)
factory.add_option("Iter", [1000])
factory.add_option("in_width_1", [4, 8, 16])
factory.add_option("in_width_2", [4, 8, 12])
factory.generate_tests()
