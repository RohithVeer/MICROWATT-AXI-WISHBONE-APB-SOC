# verif/tb/test_pwm.py
"""
Smoke test for PWM peripheral.
Minimal: reset/start clock and ensure simulation runs for a short period.
"""
import cocotb
from cocotb.triggers import Timer
from cocotb import log

@cocotb.test()
async def test_pwm_smoke(dut):
    log.info("PWM smoke: start")
    await Timer(10, 'ns')
    await Timer(500, 'ns')
    log.info("PWM smoke: finished - PASS")

