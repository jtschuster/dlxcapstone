module ALUctrl(ALUop, funct, Control);
  input [1:0] ALUop;
  input [5:0] funct;
  output [3:0] Control;
  
  wire [3:0] R_C;
  wire [3:0] J_C_add;
  wire [3:0] J_C_sub;
  wire [3:0] temp;
  wire t1, t2, t3, t4, t5, t6, t7, t8, nf0, nf1, nf2, nf3, flag;
  // R type, Control[3] = ~funct[5]
  not_gate ac_notg0 (.x(funct[5]), .z(R_C[3]));
  
  // R type Control[0] = funct[3] ^ funct[2] ^ funct[1] ^ funct[0]
  xor_gate ac_xorg0 (.x(funct[3]), .y(funct[2]), .z(t1));
  xor_gate ac_xorg1 (.x(t1), .y(funct[1]), .z(t2));
  xor_gate ac_xorg2 (.x(t2), .y(funct[0]), .z(t8));
  not_gate ac_notg5 (.x(t8), .z(R_C[0]));
  
  // R type Control[1] = ~funct[3]& ~funct[2] & ~funct[1] or ~funct[2] & funct[1] & funct[0];
  // Control[1] = ~Control[3] & Control[1]
  not_gate ac_notg1 (.x(funct[3]), .z(nf3));
  not_gate ac_notg2 (.x(funct[2]), .z(nf2));
  not_gate ac_notg3 (.x(funct[1]), .z(nf1));
  not_gate ac_notg4 (.x(funct[0]), .z(nf0));
  
  and_gate ac_andg0 (.x(nf3), .y(nf2), .z(t3));
  and_gate ac_andg1 (.x(t3), .y(nf1), .z(t4));
  
  and_gate ac_andg2 (.x(nf2), .y(funct[1]), .z(t5));
  and_gate ac_andg3 (.x(t5), .y(funct[0]), .z(t6));
  
  or_gate ac_org0 (.x(t4), .y(t6), .z(t7));
  and_gate ac_andg4 (.x(t7), .y(funct[5]), .z(R_C[1]));  
  
  // R type Control[2] = funct[1] & ~funct[2]
  and_gate ac_andg5 (.x(funct[1]), .y(nf2), .z(R_C[2]));
 
  // J type add 0011(ALUop 01) sub 0100(ALUop 10):
  mux_n #(.n(4)) ac_mux1 (.sel(ALUop[0]), .src0(R_C), .src1(4'b0011), .z(temp));
  mux_n #(.n(4)) ac_mux0 (.sel(ALUop[1]), .src0(temp), .src1(4'b0100), .z(Control));

  
  
endmodule