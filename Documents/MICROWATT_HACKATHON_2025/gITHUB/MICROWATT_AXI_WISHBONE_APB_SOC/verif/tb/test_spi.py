# verif/tb/test_spi.py
"""
Smoke test for SPI peripheral.
Minimal: reset/start clock and ensure simulation runs for a short period.
"""
import cocotb
from cocotb.triggers import Timer
from cocotb import log

@cocotb.test()
async def test_spi_smoke(dut):
    log.info("SPI smoke: start")
    # small wait to allow soc_top to apply reset/clock infrastructure
    await Timer(10, 'ns')
    # wait some cycles (keeps test minimal & resilient)
    await Timer(500, 'ns')
    log.info("SPI smoke: finished - PASS")

