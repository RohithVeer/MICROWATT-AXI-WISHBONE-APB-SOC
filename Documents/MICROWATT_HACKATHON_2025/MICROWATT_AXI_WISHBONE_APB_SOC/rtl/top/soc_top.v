`timescale 1ns/1ps

module soc_top (
  input  wire        CLK_IN,    // test expects this name
  input  wire        RESET_N,

  // Master 0 (kept for completeness)
  input  wire        m0_cyc,
  input  wire        m0_stb,
  input  wire        m0_we,
  input  wire [31:0] m0_adr,
  input  wire [31:0] m0_wdata,
  output wire [31:0] m0_rdata,
  output wire        m0_ack,

  // Master 1 (kept for completeness)
  input  wire        m1_cyc,
  input  wire        m1_stb,
  input  wire        m1_we,
  input  wire [31:0] m1_adr,
  input  wire [31:0] m1_wdata,
  output wire [31:0] m1_rdata,
  output wire        m1_ack
);

  // Forward to soc_core, mapping CLK_IN -> clk
  soc_core u_soc_core (
    .clk(CLK_IN),
    .RESET_N(RESET_N),

    .m0_cyc(m0_cyc),
    .m0_stb(m0_stb),
    .m0_we(m0_we),
    .m0_adr(m0_adr),
    .m0_wdata(m0_wdata),
    .m0_rdata(m0_rdata),
    .m0_ack(m0_ack),

    .m1_cyc(m1_cyc),
    .m1_stb(m1_stb),
    .m1_we(m1_we),
    .m1_adr(m1_adr),
    .m1_wdata(m1_wdata),
    .m1_rdata(m1_rdata),
    .m1_ack(m1_ack)
  );

`ifdef COCOTB_SIM
initial begin
  $display("[VCD] creating test_logs/soc_top.vcd");
  $dumpfile("test_logs/soc_top.vcd");
  $dumpvars(0, soc_top);
end
`endif

endmodule

