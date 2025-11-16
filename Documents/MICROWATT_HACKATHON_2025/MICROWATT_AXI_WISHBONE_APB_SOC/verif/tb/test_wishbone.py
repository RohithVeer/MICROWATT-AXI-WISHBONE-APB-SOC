import cocotb
from cocotb.triggers import RisingEdge, Timer
from cocotb.clock import Clock

# Start a clock on the top-level clock handle if present
def _start_top_clock(dut):
    if hasattr(dut, "CLK_IN"):
        cocotb.start_soon(Clock(dut.CLK_IN, 10, units="ns").start())
    elif hasattr(dut, "clk"):
        cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

@cocotb.test()
async def test_wishbone_transfer(dut):
    _start_top_clock(dut)                 # ensure clock is running

    dut._log.info("Reset")
    dut.RESET_N.value = 0                 # use .value to avoid deprecation warning
    await Timer(50, 'ns')
    dut.RESET_N.value = 1

    # Wait for a rising edge on whichever top-level clock exists
    if hasattr(dut, "CLK_IN"):
        await RisingEdge(dut.CLK_IN)
    else:
        await RisingEdge(dut.clk)

    await Timer(200, 'ns')
    dut._log.info("Wishbone smoke test done")

