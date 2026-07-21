import cocotb
from cocotb.clock import Clock
from cocotb.regression import TestFactory
from cocotb.triggers import RisingEdge, ClockCycles

async def pairwise_test_template(dut, input_bits):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    dut.aresetn.value = 0
    dut.s_valid.value = 0
    dut.s_data.value = 0
    dut.m_ready.value = 1
    await ClockCycles(dut.clk, 2)
    dut.aresetn.value = 1
    await RisingEdge(dut.clk)

    expected_pairs = [(b1 << 1) | b2 for b1, b2 in zip(input_bits[:-1], input_bits[1:])]
    actual_pairs = []

    async def monitor():
        while len(actual_pairs) < len(expected_pairs):
            await RisingEdge(dut.clk)
            if dut.m_valid.value == 1 and dut.m_ready.value == 1:
                actual_pairs.append(dut.m_data.value.integer)

    cocotb.start_soon(monitor())
    for bit in input_bits:
        dut.s_data.value = bit
        dut.s_valid.value = 1
        
        await RisingEdge(dut.clk)
        while dut.s_ready.value == 0:
            await RisingEdge(dut.clk)

    dut.s_valid.value = 0
    for _ in range(10):
        if len(actual_pairs) == len(expected_pairs):
            break
        await RisingEdge(dut.clk)

    assert actual_pairs == expected_pairs, f"Expected {expected_pairs}, got {actual_pairs}"

factory = TestFactory(test_function=pairwise_test_template)
factory.add_option(
    "input_bits",
    [
        [1, 0, 1, 1],
        [0, 0, 1, 0, 1],
        [1, 1, 1, 1],
    ],
)
factory.generate_tests()
