`timescale 1ns/1ps
module vcd_forcer_;
initial begin
  // absolute path so simulator always writes to verif/test_logs
  $dumpfile("/home/rv/Documents/MICROWATT_HACKATHON_2025/MICROWATT_AXI_WISHBONE_APB_SOC/verif/test_logs/test_sram_soc_top.vcd");
  // dump the whole top instance
  $dumpvars(0, soc_top);
  #1;
end
endmodule
