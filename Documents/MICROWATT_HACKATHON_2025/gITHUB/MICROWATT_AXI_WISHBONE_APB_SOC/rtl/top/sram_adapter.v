// sram_adapter.v (idempotent overwrite)
`timescale 1ns/1ps
module sram_adapter (
  input  wire        clk,
  input  wire        s0_cyc,
  input  wire        s0_stb,
  input  wire        s0_we,
  input  wire [31:0] s0_adr,
  input  wire [31:0] s0_wdata,
  output wire [31:0] s0_rdata,
  output wire        s0_ack
);
  wire csb0  = ~s0_stb;
  wire web0  = ~s0_we;
  wire [7:0] addr0 = s0_adr[7:0];

  sram_wrapper u_sram (
    .clk0(clk),
    .csb0(csb0),
    .web0(web0),
    .addr0(addr0),
    .din0(s0_wdata),
    .dout0(s0_rdata),
    .clk1(clk),
    .csb1(1'b1),
    .addr1(8'd0),
    .dout1()
  );

  assign s0_ack = s0_stb;
endmodule
