`timescale 1ns/1ps
module soc_core (
  input  wire        clk,
  input  wire        RESET_N,
  input  wire        m0_cyc,
  input  wire        m0_stb,
  input  wire        m0_we,
  input  wire [31:0] m0_adr,
  input  wire [31:0] m0_wdata,
  output wire [31:0] m0_rdata,
  output wire        m0_ack,
  input  wire        m1_cyc,
  input  wire        m1_stb,
  input  wire        m1_we,
  input  wire [31:0] m1_adr,
  input  wire [31:0] m1_wdata,
  output wire [31:0] m1_rdata,
  output wire        m1_ack
);
  wire rst = ~RESET_N;

  wire        s0_cyc, s0_stb, s0_we;
  wire [31:0] s0_adr, s0_wdata;
  wire [31:0] s0_rdata;
  wire        s0_ack;

  wire        s1_cyc, s1_stb, s1_we;
  wire [31:0] s1_adr, s1_wdata;
  wire [31:0] s1_rdata;
  wire        s1_ack;

  wire        s2_cyc, s2_stb, s2_we;
  wire [31:0] s2_adr, s2_wdata;
  wire [31:0] s2_rdata;
  wire        s2_ack;

  assign s1_rdata = 32'h0;
  assign s1_ack   = 1'b0;
  assign s2_rdata = 32'h0;
  assign s2_ack   = 1'b0;

  wishbone_interconnect #(.AW(32), .DW(32)) u_interconnect (
    .m0_cyc(m0_cyc), .m0_stb(m0_stb), .m0_we(m0_we), .m0_adr(m0_adr), .m0_wdata(m0_wdata), .m0_rdata(m0_rdata), .m0_ack(m0_ack),
    .m1_cyc(m1_cyc), .m1_stb(m1_stb), .m1_we(m1_we), .m1_adr(m1_adr), .m1_wdata(m1_wdata), .m1_rdata(m1_rdata), .m1_ack(m1_ack),
    .s0_cyc(s0_cyc), .s0_stb(s0_stb), .s0_we(s0_we), .s0_adr(s0_adr), .s0_wdata(s0_wdata), .s0_rdata(s0_rdata), .s0_ack(s0_ack),
    .s1_cyc(s1_cyc), .s1_stb(s1_stb), .s1_we(s1_we), .s1_adr(s1_adr), .s1_wdata(s1_wdata), .s1_rdata(s1_rdata), .s1_ack(s1_ack),
    .s2_cyc(s2_cyc), .s2_stb(s2_stb), .s2_we(s2_we), .s2_adr(s2_adr), .s2_wdata(s2_wdata), .s2_rdata(s2_rdata), .s2_ack(s2_ack)
  );

  sram_adapter u_sram_adapter (
    .clk(clk),
    .s0_cyc(s0_cyc),
    .s0_stb(s0_stb),
    .s0_we(s0_we),
    .s0_adr(s0_adr),
    .s0_wdata(s0_wdata),
    .s0_rdata(s0_rdata),
    .s0_ack(s0_ack)
  );

endmodule
