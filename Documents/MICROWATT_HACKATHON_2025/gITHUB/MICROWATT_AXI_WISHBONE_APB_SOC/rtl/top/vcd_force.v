module vcd_force();
  reg [1023:0] fn;
  reg [1023:0] logdir;
  initial begin
    // 1) plusarg override (highest priority)
    if ($value$plusargs("vcd=%s", fn)) begin end
    else begin
      // 2) env var VCD_FILE (if available)
      fn = $getenv("VCD_FILE");
      // 3) fallback: cocotb always sets COCOTB_LOG_DIR to per-test dir
      if (fn == "" || fn == "VCD_FILE") begin
        logdir = $getenv("COCOTB_LOG_DIR");
        if (logdir == "") begin
          fn = "dump.vcd";
        end else begin
          fn = $sformatf("%s/dump.vcd", logdir);
        end
      end
    end
    $display("vcd_force: writing VCD to %0s", fn);
    $dumpfile(fn);
    $dumpvars(0, soc_top);   // FULL hierarchy
  end
endmodule
