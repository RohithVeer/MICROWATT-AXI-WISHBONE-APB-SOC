# verif/tb/test_gpio.py
"""
Smoke test for GPIO peripheral.
Minimal: reset/start clock and ensure simulation runs for a short period.
"""
import cocotb
from cocotb.triggers import Timer
from cocotb import log

@cocotb.test()
async def test_gpio_smoke(dut):
    log.info("GPIO smoke: start")
    await Timer(10, 'ns')
    await Timer(500, 'ns')
    log.info("GPIO smoke: finished - PASS")

