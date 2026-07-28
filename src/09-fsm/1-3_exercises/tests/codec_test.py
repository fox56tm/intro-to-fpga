import random

import cocotb
from cocotb.clock import Clock
from cocotb.regression import TestFactory
from cocotb.triggers import ClockCycles, ReadOnly, RisingEdge

ALPHABET = [ord("A"), ord("T"), ord("G"), ord("C")]


class HelperCodec:
    def __init__(self, dut):
        self.dut = dut
        self.expected = []

    async def generate_rnd_input(self):
        while True:
            self.dut.byte_in.value = random.choice(ALPHABET)
            self.dut.s_valid.value = random.randint(0, 1)
            self.dut.m_ready.value = random.randint(0, 1)
            await RisingEdge(self.dut.clk)

    async def initialize_rst(self):
        self.dut.aresetn.value = 0
        await ClockCycles(self.dut.clk, 2)
        self.dut.aresetn.value = 1

    def setup(self):
        self.dut.s_valid.value = 0
        self.dut.byte_in.value = 0
        self.dut.m_ready.value = 0

    async def my_encoder(self):
        while True:
            await RisingEdge(self.dut.clk)
            if self.dut.s_ready.value and self.dut.s_valid.value:
                self.expected.append(self.dut.byte_in.value.integer)

    async def check_output(self):
        while True:
            await RisingEdge(self.dut.clk)
            await ReadOnly()
            if self.dut.m_valid.value == 1 and self.dut.m_ready.value == 1:
                expected_val = self.expected.pop(0)
                actual = self.dut.char_out.value.integer
                assert actual == expected_val, (
                    f"Error! Got: {actual}, Expected: {expected_val}"
                )


async def run_codec_test(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    helper = HelperCodec(dut)

    helper.setup()
    await helper.initialize_rst()
    await RisingEdge(dut.clk)

    cocotb.start_soon(helper.generate_rnd_input())
    cocotb.start_soon(helper.my_encoder())
    cocotb.start_soon(helper.check_output())
    await ClockCycles(dut.clk, 1000)


factory = TestFactory(test_function=run_codec_test)
factory.generate_tests()
