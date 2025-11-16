module apb_gpio(
input wire pclk, presetn,
input wire psel, penable, pwrite,
input wire [31:0] paddr, pwdata,
output reg [31:0] prdata, output reg pready,
output reg [3:0] gpio_out, input wire [3:0] gpio_in
);
reg [31:0] gpio_reg;
always @(posedge pclk) begin
if (!presetn) begin gpio_reg <= 0; pready<=0; end
else begin
pready <= 0;
if (psel && penable) begin
pready <= 1;
if (pwrite) gpio_reg <= pwdata;
prdata <= gpio_reg;
end
gpio_out <= gpio_reg[3:0];
end
end
endmodule
