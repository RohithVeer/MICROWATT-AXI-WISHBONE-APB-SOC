module wb_to_apb #(
parameter AW=32, DW=32
)(
input wire clk, input wire rst,
// Wishbone master side
input wire m_cyc, input wire m_stb, input wire m_we,
input wire [AW-1:0] m_adr, input wire [DW-1:0] m_wdata,
output reg [DW-1:0] m_rdata, output reg m_ack,
// APB side (single slave)
output reg psel, output reg penable, output reg pwrite,
output reg [AW-1:0] paddr, output reg [DW-1:0] pwdata,
input wire [DW-1:0] prdata, input wire pready
);
reg state;
always @(posedge clk) begin
if (rst) begin state<=0; m_ack<=0; psel<=0; penable<=0; end
else begin
m_ack <= 0;
case (state)
0: begin
if (m_cyc && m_stb) begin
// start APB transfer
psel <= 1; pwrite <= m_we; paddr <= m_adr; pwdata <= m_wdata; penable <= 0; state<=1;
end
end
1: begin
penable <= 1; // APB active
if (pready) begin
m_ack <= 1; m_rdata <= prdata; psel<=0; penable<=0; state<=0;
end
end
endcase
end
end
endmodule
