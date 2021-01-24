module alu_unit (A, B, Op, Carryout, Carryin, usum);
  input A;
  input B;
  input wire[3:0] Op;
  output Carryout;
  output usum;
  input Carryin;
  wire Carryout_0;
  wire uand;
  wire uor;
  wire uadd;
  wire uxor;
  wire usub;
  wire t1;
  wire t2;
  wire t3;
  wire t4;
  wire t5;
  wire t_add;
  wire t_not;
  wire t_carry;
  wire t_sum1;
  wire t_sum2;
  wire t_sum3;
  wire t_sum4;
  wire t_sum5;
  wire B_inv;
  wire B_slt;
  //and
  and_gate and_1 (.x(A), .y(B), .z(uand));
  //or
  or_gate or_1 (.x(A), .y(B), .z(uor));
  //xor
  xor_gate xor_1 (.x(A), .y(B), .z(uxor));
  //b_inverse
  not_gate not_1 (.x(B), .z(B_inv));
  mux mux_1 (.sel(Op[2]), .src0(B), .src1(B_inv), .z(B_slt));
  //add_sum
  xor_gate xor_2 (.x(A),.y(B_slt), .z(t1));
  xor_gate xor_3 (.x(t1),.y(Carryin), .z(uadd));

  //Carryout
  and_gate and_add1 (.x(A), .y(B_slt), .z(t2));
  and_gate and_add2 (.x(A), .y(Carryin), .z(t3));
  and_gate and_add3 (.x(B_slt), .y(Carryin), .z(t4));
  or_gate or_add1 (.x(t2), .y(t3), .z(t5));
  or_gate or_add2 (.x(t5), .y(t4), .z(Carryout_0));
  
  
  
	//sum
    and_gate andop (.x(Op[0]), .y(Op[1]), .z(t_add));
	not_gate andop1 (.x(t_add),.z(t_not));
	mux muxop0 (.sel(Op[0]), .src0(uand), .src1(uor), .z(t_sum1));
	mux muxop1 (.sel(Op[1]), .src0(t_sum1), .src1(uadd), .z(t_sum2));
	mux muxop3 (.sel(Op[2]), .src0(t_sum2), .src1(uadd), .z(usum));
	
	// Carryout
	or_gate orcarry(.x(Op[1]), .y(Op[2]), .z(t_carry));
	and_gate andcarry (.x(t_carry), .y(Carryout_0), .z(Carryout));
	
	
  

	

  
endmodule

