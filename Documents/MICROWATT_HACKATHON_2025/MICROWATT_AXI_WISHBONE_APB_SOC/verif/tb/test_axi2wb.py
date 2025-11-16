# verif/tb/test_axi2wb.py
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

def _start_clock_on_top(dut, period_ns=10):
    """Start a clock on the top-level clock if present (CLK_IN or clk)."""
    if hasattr(dut, "CLK_IN"):
        cocotb.start_soon(Clock(dut.CLK_IN, period_ns, units="ns").start())
    elif hasattr(dut, "clk"):
        cocotb.start_soon(Clock(dut.clk, period_ns, units="ns").start())

@cocotb.test()
async def test_axi2wb_smoke(dut):
    """AXI-Lite -> Wishbone smoke test (reset, start clock, simple poke)."""
    dut._log.info("AXI2WB smoke: start")

    # Start top clock if present
    _start_clock_on_top(dut, period_ns=10)

    # Apply active-low reset (use .value to avoid deprecation warnings)
    if hasattr(dut, "RESET_N"):
        dut.RESET_N.value = 0
    elif hasattr(dut, "reset_n"):
        dut.reset_n.value = 0
    else:
        dut._log.warning("No top-level RESET_N/reset_n found; continuing without reset pulse")

    await Timer(100, units="ns")

    if hasattr(dut, "RESET_N"):
        dut.RESET_N.value = 1
    elif hasattr(dut, "reset_n"):
        dut.reset_n.value = 1

    # Wait a clock edge to let everything settle
    # prefer CLK_IN, fall back to clk if available; else just wait some time
    if hasattr(dut, "CLK_IN"):
        await RisingEdge(dut.CLK_IN)
    elif hasattr(dut, "clk"):
        await RisingEdge(dut.clk)
    else:
        await Timer(50, units="ns")

    # Simple poke of top-level WB/AXI-like master ports if they exist.
    # This is intentionally minimal: a single short write pulse so the bridge sees activity.
    try:
        # Wishbone-style master signals on soc_top are named m0_* in this project
        if hasattr(dut, "m0_cyc") and hasattr(dut, "m0_stb") and hasattr(dut, "m0_we"):
            dut._log.info("Poking top-level WB master (m0_*) signals")
            dut.m0_adr.value = 0
            dut.m0_wdata.value = 0xDEADBEEF
            dut.m0_we.value   = 1
            dut.m0_cyc.value  = 1
            dut.m0_stb.value  = 1
            await Timer(40, units="ns")
            dut.m0_stb.value  = 0
            dut.m0_cyc.value  = 0
            dut.m0_we.value   = 0

        # If an AXI-lite top master exists (common names), poke a minimal write
        if hasattr(dut, "axi_awvalid") and hasattr(dut, "axi_wvalid"):
            dut._log.info("Poking top-level AXI-lite-ish signals (axi_awvalid/axi_wvalid)")
            try:
                dut.axi_awaddr.value = 0
                dut.axi_wdata.value  = 0xA5A5A5A5
            except Exception:
                # Some nets may not exist or be nested; ignore safely
                pass
            dut.axi_awvalid.value = 1
            dut.axi_wvalid.value  = 1
            await Timer(40, units="ns")
            dut.axi_awvalid.value = 0
            dut.axi_wvalid.value  = 0

    except Exception as e:
        dut._log.warning(f"Top-level poke failed (non-fatal): {e}")

    # Let simulation run some more cycles so the bridge logic can process signals
    await Timer(500, units="ns")

    dut._log.info("AXI2WB smoke test finished")

