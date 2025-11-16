module apb_uart(
input wire pclk, presetn,
input wire psel, penable, pwrite,
input wire [31:0] paddr, pwdata,
output reg [31:0] prdata, output reg pready,
output reg tx, input wire rx
);
reg [7:0] txbuf;
always @(posedge pclk) begin
if (!presetn) begin txbuf<=0; prdata<=0; pready<=0; tx<=1'b1; end
else begin
pready <= 0;
if (psel && penable) begin
pready <= 1;
if (pwrite) txbuf <= pwdata[7:0];
prdata <= {24'b0, txbuf};
end
end
end
endmodule
