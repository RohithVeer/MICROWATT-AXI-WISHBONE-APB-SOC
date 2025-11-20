module sram_wrapper (
  input  wire         clk0,
  input  wire         csb0,
  input  wire         web0,
  input  wire  [7:0]  addr0,
  input  wire [31:0]  din0,
  output wire [31:0]  dout0,
  input  wire         clk1,
  input  wire         csb1,
  input  wire  [7:0]  addr1,
  output wire [31:0]  dout1
);
  // instantiated as blackbox in synthesis/PnR. In verification we use beh_sram from verif/sim
  // Create ports identical to SkyWater naming for easy swap.
  // No internal implementation here.
endmodule

