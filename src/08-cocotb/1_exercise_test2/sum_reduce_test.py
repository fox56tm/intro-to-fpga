import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, FallingEdge
from cocotb.types import LogicArray
import random
from cocotb.regression import TestFactory

class HelperSumReduce:

    def __init__(self, dut, count_of_bits):
        self.dut = dut
        self.count_of_bits = count_of_bits
        self.sum = 0
        self.num = 0
        self.acc = 0

    async def initialize_rst(self):
        self.dut.num.value = 0
        self.dut.rst.value = 1
        await ClockCycles(self.dut.clk, 2)
        self.dut.rst.value = 0
    
    def my_sum_reduce(self,num):
        self.sum = (self.acc + num) % (2**self.count_of_bits)

    def update(self):
        self.acc = self.sum


async def run_sum_reduce_test(dut, Iter, count_of_bits):
    clock = Clock(dut.clk, 10, units="ns")
    helper = HelperSumReduce(dut, count_of_bits)
    cocotb.start_soon(clock.start(start_high=False))

    await helper.initialize_rst()
    await RisingEdge(dut.clk)

    for _ in range(Iter):
        maxx = (2**helper.count_of_bits) - 1
        rnd_val = random.randint(0, maxx)

        dut.num.value = rnd_val
        helper.my_sum_reduce(rnd_val)
        await RisingEdge(dut.clk)
        assert dut.sum.value.integer == helper.sum, f"ERROR {dut.sum.value.integer}, expec: {helper.sum}"
        helper.update()

factory = TestFactory(test_function=run_sum_reduce_test)
factory.add_option("Iter", [1000])
factory.add_option("count_of_bits", [8])
factory.generate_tests()
