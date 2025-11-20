`timescale 1ns/1ps
module vcd_forcer_test_sram;
initial begin
  $dumpfile("verif/test_logs/test_sram.vcd");
  // dump whole tree under the top-level instance soc_top (use soc_top or tb_sram as appropriate)
  $dumpvars(0, soc_top);
  #1; // tiny hold
end
endmodule
