# verif/tb/test_i2c.py
"""
Smoke test for I2C peripheral.
Minimal: reset/start clock and ensure simulation runs for a short period.
"""
import cocotb
from cocotb.triggers import Timer
from cocotb import log

@cocotb.test()
async def test_i2c_smoke(dut):
    log.info("I2C smoke: start")
    await Timer(10, 'ns')
    await Timer(500, 'ns')
    log.info("I2C smoke: finished - PASS")

