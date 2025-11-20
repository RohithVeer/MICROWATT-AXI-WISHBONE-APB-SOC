module apb_spi(
input wire pclk, presetn,
input wire psel, penable, pwrite,
input wire [31:0] paddr, pwdata,
output reg [31:0] prdata, output reg pready,
output reg mosi, input wire miso, output reg sck, output reg cs
);
always @(posedge pclk) begin
if (!presetn) begin prdata<=0; pready<=0; mosi<=0; sck<=0; cs<=1; end
else begin
pready<=0;
if (psel && penable) begin pready<=1; prdata<=0; end
end
end
endmodule
