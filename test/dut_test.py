# ram_verification.py

import cocotb
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles
from cocotb.result import TestFailure
from cocotb.binary import BinaryValue

@cocotb.coroutine
def write_to_ram(dut, address, data):
    dut.addr_i <= address
    dut.data_i <= data
    dut.wr_en_i <= 1
    yield RisingEdge(dut.clk_i)
    dut.wr_en_i <= 0

@cocotb.coroutine
def read_from_ram(dut, address):
    dut.addr_i <= address
    dut.rd_en_i <= 1
    yield RisingEdge(dut.clk_i)
    dut.rd_en_i <= 0
    yield RisingEdge(dut.clk_i)

@cocotb.test()
def test_ram(dut):
    dut.clk_i <= 0

    # Reset the DUT
    dut.rst_n_i <= 0
    yield ClockCycles(dut.clk_i, 5)
    dut.rst_n_i <= 1
    yield ClockCycles(dut.clk_i, 5)

    # Test RAM functionality
    for i in range(256):
        data = i * 2
        yield write_to_ram(dut, i, data)

    for i in range(256):
        yield read_from_ram(dut, i)
        expected_data = i * 2
        if dut.data_o != expected_data:
            raise TestFailure(f"Data mismatch at address {i}. Expected: {expected_data}, Got: {dut.data_o}")

    # Add more tests if needed
