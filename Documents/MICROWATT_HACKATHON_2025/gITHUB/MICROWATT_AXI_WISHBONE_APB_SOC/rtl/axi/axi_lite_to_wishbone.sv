module axi_lite_to_wishbone #(
parameter AW = 32, parameter DW = 32
)(
// AXI-lite slave side (narrowed external pins simplified in top)
input wire s_awvalid,
input wire [AW-1:0] s_awaddr,
output wire s_awready,
input wire s_wvalid,
input wire [DW-1:0] s_wdata,
output wire s_wready,
output wire s_bvalid,
input wire s_bready,
input wire s_arvalid,
input wire [AW-1:0] s_araddr,
output wire s_arready,
output wire s_rvalid,
output wire [DW-1:0] s_rdata,
input wire s_rready,


// Wishbone master interface
output reg m_cyc,
output reg m_stb,
output reg m_we,
output reg [AW-1:0] m_adr,
output reg [DW-1:0] m_wdata,
input wire [DW-1:0] m_rdata,
input wire m_ack
);


// Very simple combinational handshake bridging
assign s_awready = 1'b1;
assign s_wready = 1'b1;
assign s_arready = 1'b1;


assign s_bvalid = 1'b0; // simple, not producing B responses


reg [DW-1:0] rdata_q;
assign s_rdata = rdata_q;
assign s_rvalid = 1'b0;


always @(*) begin
// idle pass-through; for full functionality extend as needed
m_cyc = s_awvalid | s_arvalid | s_wvalid;
m_stb = m_cyc;
m_we = s_wvalid;
m_adr = s_awaddr | s_araddr;
m_wdata = s_wdata;
end


endmodule
