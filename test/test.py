# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
  dut._log.info("Start")
  
  # Our example module doesn't use clock and reset, but we show how to use them here anyway.
  clock = Clock(dut.clk, 10, units="us")
  cocotb.start_soon(clock.start())

  # Reset
  dut._log.info("Reset")
  dut.ena.value = 1
  dut.ui_in.value = 0
  dut.uio_in.value = 0
  dut.rst_n.value = 0
  await ClockCycles(dut.clk, 10)
  dut.rst_n.value = 1

  # Test case 1: Input sequence doesn't trigger detection
    dut._log.info("Test case 1")
    dut.ui_in.value = 0b00000001  # Input sequence that doesn't trigger detection
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0b00000010  # Expected output when sequence not detected

    # Test case 2: Input sequence triggers detection
    dut._log.info("Test case 2")
    dut.ui_in.value = 0b11111111  # Input sequence that triggers detection
    dut.uio_in.value = 0b11111111  # Set uio_in to a non-zero value
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0b11111111  # Expected output when sequence detected

    # Test case 3: Input sequence triggers detection with different uio_in value
    dut._log.info("Test case 3")
    dut.ui_in.value = 0b11111111  # Input sequence that triggers detection
    dut.uio_in.value = 0b00000001  # Set uio_in to a non-zero value
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0b00000001  # Expected output when sequence detected with different uio_in

    # Test case 4: Input sequence triggers detection with different uio_in value
    dut._log.info("Test case 4")
    dut.ui_in.value = 0b11111111  # Input sequence that triggers detection
    dut.uio_in.value = 0b01010101  # Set uio_in to a non-zero value
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0b01010101  # Expected output when sequence detected with different uio_in
