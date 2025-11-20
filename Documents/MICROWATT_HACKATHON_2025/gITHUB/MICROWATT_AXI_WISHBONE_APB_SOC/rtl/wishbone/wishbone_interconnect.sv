module wishbone_interconnect #( parameter AW = 32, parameter DW = 32 )
(
    // Master 0 (priority)
    input  wire               m0_cyc,
    input  wire               m0_stb,
    input  wire               m0_we,
    input  wire [AW-1:0]      m0_adr,
    input  wire [DW-1:0]      m0_wdata,
    output reg  [DW-1:0]      m0_rdata,
    output reg                m0_ack,

    // Master 1 (secondary/testbench)
    input  wire               m1_cyc,
    input  wire               m1_stb,
    input  wire               m1_we,
    input  wire [AW-1:0]      m1_adr,
    input  wire [DW-1:0]      m1_wdata,
    output reg  [DW-1:0]      m1_rdata,
    output reg                m1_ack,

    // Slave 0 (SRAM)
    output reg                s0_cyc,
    output reg                s0_stb,
    output reg                s0_we,
    output reg  [AW-1:0]      s0_adr,
    output reg  [DW-1:0]      s0_wdata,
    input  wire [DW-1:0]      s0_rdata,
    input  wire               s0_ack,

    // Slave 1 (WB->APB bridge)
    output reg                s1_cyc,
    output reg                s1_stb,
    output reg                s1_we,
    output reg  [AW-1:0]      s1_adr,
    output reg  [DW-1:0]      s1_wdata,
    input  wire [DW-1:0]      s1_rdata,
    input  wire               s1_ack,

    // Slave 2 (Debug region)
    output reg                s2_cyc,
    output reg                s2_stb,
    output reg                s2_we,
    output reg  [AW-1:0]      s2_adr,
    output reg  [DW-1:0]      s2_wdata,
    input  wire [DW-1:0]      s2_rdata,
    input  wire               s2_ack
);

// Address decode (simple ranges matching spec)
localparam S0_BASE = 32'h0000_0000;
localparam S1_BASE = 32'h1000_0000;
localparam S2_BASE = 32'h2000_0000;

// arbitration: master 1 (tb) wins only if M0 not active
always @(*) begin
  // default slaves idle
  s0_cyc = 0; s0_stb = 0; s0_we = 0; s0_adr = 0; s0_wdata = 0;
  s1_cyc = 0; s1_stb = 0; s1_we = 0; s1_adr = 0; s1_wdata = 0;
  s2_cyc = 0; s2_stb = 0; s2_we = 0; s2_adr = 0; s2_wdata = 0;

  // choose master
  if (m0_cyc) begin
    case (m0_adr & 32'hF000_0000)
      S0_BASE: begin s0_cyc=1; s0_stb=1; s0_we=m0_we; s0_adr=m0_adr; s0_wdata=m0_wdata; end
      S1_BASE: begin s1_cyc=1; s1_stb=1; s1_we=m0_we; s1_adr=m0_adr; s1_wdata=m0_wdata; end
      S2_BASE: begin s2_cyc=1; s2_stb=1; s2_we=m0_we; s2_adr=m0_adr; s2_wdata=m0_wdata; end
      default: begin end
    endcase
  end else if (m1_cyc) begin
    case (m1_adr & 32'hF000_0000)
      S0_BASE: begin s0_cyc=1; s0_stb=1; s0_we=m1_we; s0_adr=m1_adr; s0_wdata=m1_wdata; end
      S1_BASE: begin s1_cyc=1; s1_stb=1; s1_we=m1_we; s1_adr=m1_adr; s1_wdata=m1_wdata; end
      S2_BASE: begin s2_cyc=1; s2_stb=1; s2_we=m1_we; s2_adr=m1_adr; s2_wdata=m1_wdata; end
      default: begin end
    endcase
  end
end

// simple ack/rdata routing -- route s0/s1/s2 responses back to active master
always @(*) begin
  m0_ack = 0; m0_rdata = 0;
  m1_ack = 0; m1_rdata = 0;
  if (s0_ack) begin
    if (m0_cyc) begin m0_ack = s0_ack; m0_rdata = s0_rdata; end
    else if (m1_cyc) begin m1_ack = s0_ack; m1_rdata = s0_rdata; end
  end
  if (s1_ack) begin
    if (m0_cyc) begin m0_ack = s1_ack; m0_rdata = s1_rdata; end
    else if (m1_cyc) begin m1_ack = s1_ack; m1_rdata = s1_rdata; end
  end
  if (s2_ack) begin
    if (m0_cyc) begin m0_ack = s2_ack; m0_rdata = s2_rdata; end
    else if (m1_cyc) begin m1_ack = s2_ack; m1_rdata = s2_rdata; end
  end
end

endmodule
