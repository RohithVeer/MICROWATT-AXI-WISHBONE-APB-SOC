import cocotb
from cocotb.triggers import RisingEdge, Timer
from cocotb.clock import Clock

async def _maybe_start_clock(dut):
    """Start a 10 ns clock on DUT.CLK_IN (preferred) otherwise dut.clk if present."""
    clk_handle = dut.CLK_IN if hasattr(dut, "CLK_IN") else (dut.clk if hasattr(dut, "clk") else None)
    if clk_handle is not None:
        cocotb.start_soon(Clock(clk_handle, 10, units="ns").start())

@cocotb.test()
async def test_sram(dut):
    """Smoke test: reset and let WB master make writes; ensure simulation runs."""
    dut._log.info("Applying reset")

    # start the clock for the DUT (safe: done while `dut` exists)
    await _maybe_start_clock(dut)

    # use the .value API (recommended)
    try:
        dut.RESET_N.value = 0
    except AttributeError:
        # fallback if signal name differs
        if hasattr(dut, "reset_n"):
            dut.reset_n.value = 0
        else:
            raise

    await Timer(100, 'ns')

    # deassert reset
    dut.RESET_N.value = 1

    # wait for one rising edge and a bit more time to allow the DUT to run
    clk = dut.CLK_IN if hasattr(dut, "CLK_IN") else (dut.clk if hasattr(dut, "clk") else None)
    if clk is not None:
        await RisingEdge(clk)
    await Timer(500, 'ns')

    dut._log.info("Smoke test finished")


