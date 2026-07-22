import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, ReadOnly
from cocotb.regression import TestFactory
import random
import struct
import math

def float_to_uint32(val: float) -> int:
    return struct.unpack('<I', struct.pack('<f', val))[0]

def uint32_to_float(val: int) -> float:
    return struct.unpack('<f', struct.pack('<I', val))[0]

class HelperConv1d:
    def __init__(self, dut, kernel_size):
        self.dut = dut
        self.kernel_size = kernel_size
        self.weights = []
        self.bytes = [0] * kernel_size
        self.counter = 0
        self.expected = []

    async def generate_rnd_input(self):
        while True:
            self.dut.weight_in.value = float_to_uint32(random.uniform(1.0, 5.0))
            self.dut.w_valid.value = random.randint(0, 1)
            self.dut.s_data.value = random.randint(0, 1)
            self.dut.s_valid.value = random.randint(0, 1)
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
        self.dut.weight_in.value = float_to_uint32(0.0)
        self.dut.w_valid.value = 0
    
    async def my_conv1d(self):
        while True:
            await RisingEdge(self.dut.clk)
            if self.counter < self.kernel_size:
                if(self.dut.w_ready.value and self.dut.w_valid.value):
                    in_w = self.dut.weight_in.value.integer
                    real_w = uint32_to_float(in_w)
                    self.weights.append(real_w)
                    self.counter+=1
            w_r = self.dut.win_ready.value
            w_v = self.dut.win_valid.value
            if(w_v and w_r):
                self.bytes.append(self.dut.curr_byte.value.integer)
                self.bytes.pop(0)
                if((self.counter == self.kernel_size)):
                    total = 0
                    for i in range(0, self.kernel_size):
                        prod = self.weights[i] * self.bytes[i]
                        prod_int = int(prod) 
                        prod_int = min(prod_int, 255)
                        total += prod_int
                    expected_val = min(total, 255)
                    self.expected.append(expected_val)

    async def check_output(self):
        while True:
            await RisingEdge(self.dut.clk)
            await ReadOnly()
            if self.dut.m_valid.value == 1 and self.dut.m_ready.value == 1:
                expected_val = self.expected.pop(0)
                actual = self.dut.m_data.value.integer
                assert actual == expected_val, f"Error! Got: {actual}, Expected: {expected_val}"

async def run_conv1d_test(dut, kernel_size):
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    helper = HelperConv1d(dut, kernel_size)

    helper.setup()
    await helper.initialize_rst()
    await RisingEdge(dut.clk)

    cocotb.start_soon(helper.generate_rnd_input())
    cocotb.start_soon(helper.my_conv1d())
    cocotb.start_soon(helper.check_output())
    await ClockCycles(dut.clk,1000)

factory = TestFactory(test_function=run_conv1d_test)
factory.add_option("kernel_size", [3])
factory.generate_tests()
