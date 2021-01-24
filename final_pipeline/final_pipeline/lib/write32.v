module write32(clk, din, to);
  input clk;
  input [31:0] din;
  output [31:0] to;
  
  
  generate 
  genvar index;
  for (index=0; index < 32; index = index + 1)
	begin
        dff dff_w_32 (.clk(clk), .d(din[index]), .q(to[index]));
	end
  endgenerate
endmodule
