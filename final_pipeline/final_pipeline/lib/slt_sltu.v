module slt_sltu ( overflow, MSB, cout, input31_0, sel, z);
  input overflow;
  input MSB;
  input cout;
  input sel;
  input [30:0] input31_0;
  output [31:0] z;

  wire z_slt;
  wire z_tmp;
mux mux_slt (.sel(overflow), .src0(MSB), .src1(cout), .z(z_slt));
mux mux_slt_sltu (.sel(sel), .src0(z_slt), .src1(MSB), .z(z_tmp));
assign z[0] = z_tmp;
assign z[31:1] = input31_0;
endmodule
