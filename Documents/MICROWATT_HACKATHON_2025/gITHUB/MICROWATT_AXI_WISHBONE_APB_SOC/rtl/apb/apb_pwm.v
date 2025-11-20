module apb_pwm(
input wire pclk, presetn,
input wire psel, penable, pwrite,
input wire [31:0] paddr, pwdata,
output reg [31:0] prdata, output reg pready,
output reg pwm0, pwm1
);
reg [15:0] ctr0, ctr1, top0, top1;
always @(posedge pclk) begin
if (!presetn) begin ctr0<=0; ctr1<=0; top0<=100; top1<=200; prdata<=0; pready<=0; end
else begin
pready<=0;
ctr0<=ctr0+1; ctr1<=ctr1+1;
pwm0 <= (ctr0 < top0);
pwm1 <= (ctr1 < top1);
if (psel && penable) begin pready<=1; if (pwrite) begin top0<=pwdata[15:0]; top1<=pwdata[31:16]; end end
end
end
endmodule
