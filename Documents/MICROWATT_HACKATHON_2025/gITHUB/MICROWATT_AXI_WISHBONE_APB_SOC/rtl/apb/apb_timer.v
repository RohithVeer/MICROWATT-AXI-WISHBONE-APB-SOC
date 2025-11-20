module apb_timer(
input wire pclk, presetn,
input wire psel, penable, pwrite,
input wire [31:0] paddr, pwdata,
output reg [31:0] prdata, output reg pready,
output reg irq
);
reg [31:0] cnt, reload;
always @(posedge pclk) begin
if (!presetn) begin cnt<=0; reload<=100000; irq<=0; prdata<=0; pready<=0; end
else begin
pready<=0; irq<=0;
cnt<=cnt+1;
if (cnt==reload) begin irq<=1; cnt<=0; end
if (psel && penable) begin pready<=1; if (pwrite) reload<=pwdata; prdata<=cnt; end
end
end
endmodule
