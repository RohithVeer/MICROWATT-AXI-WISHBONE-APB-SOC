import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge

def _maybe_start_clock(dut):
    # start a 10ns clock on a top-level clock handle if present
    if hasattr(dut, "CLK_IN"):
        cocotb.start_soon(Clock(dut.CLK_IN, 10, units="ns").start())
    elif hasattr(dut, "clk"):
        cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

@cocotb.test()
async def test_wb_to_apb(dut):
    """Simple smoke: reset, start clock, and ensure the WB->APB bridge does not hang."""
    _maybe_start_clock(dut)

    dut._log.info("Applying reset")
    if hasattr(dut, "RESET_N"):
        dut.RESET_N.value = 0
        await Timer(100, "ns")
        dut.RESET_N.value = 1
    else:
        dut._log.warning("No RESET_N found on DUT; continuing without reset")

    await RisingEdge(dut.CLK_IN if hasattr(dut, "CLK_IN") else dut.clk)
    await Timer(500, "ns")
    dut._log.info("WB->APB smoke test finished")


