module alu_msb (A, B, Op, Carryout, Carryin, usum, Overflow, Set);
  input A;
  input B;
  input [3:0] Op;
  output Carryout;
  output usum;
  output Overflow;
  output Set;
  input wire Carryin;
  wire uand;
  wire uor;
  wire uadd;
  wire uxor;
  wire usub;
  wire Overflow_0;
  wire Carryout_0;
  wire t1;
  wire t2;
  wire t3;
  wire t4;
  wire t5;
  wire t6;
  wire t7;
  wire t8;
  wire t9;
  wire t10;
  wire t11;
  wire t12;
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
  wire t_slt0;
  wire t_slt;
  wire t_sltu;
  wire t_sltu0;
  wire t_overflow;
   wire t_sub_xor;
   
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
  
  
  
	//choose output which sum
    	and_gate andop (.x(Op[0]), .y(Op[1]), .z(t_add));
	not_gate andop1 (.x(t_add),.z(t_not));
	mux muxop0 (.sel(Op[0]), .src0(uand), .src1(uor), .z(t_sum1));
	mux muxop1 (.sel(Op[1]), .src0(t_sum1), .src1(uadd), .z(t_sum2));
   	mux muxop2 (.sel(Op[1]), .src0(uxor), .src1(uadd), .z(t_sub_xor));
	mux muxop3 (.sel(Op[2]), .src0(t_sum2), .src1(t_sub_xor), .z(usum));

	
	
	// output Carryout
	or_gate orcarry(.x(Op[1]), .y(Op[2]), .z(t_carry));
	and_gate andcarry (.x(t_carry), .y(Carryout_0), .z(Carryout));
    
	//Overflow
    	xor_gate xor_setlabel(.x(t_add), .y(Op[2]), .z(t_overflow));
	xor_gate xor_overflow(.x(Carryout), .y(Carryin), .z(Overflow_0));
	and_gate andoverflow (.x(t_overflow), .y(Overflow_0), .z(Overflow));

    
	//Set slt
	xor_gate xorslt (.x(usum), .y(Overflow), .z(t_slt0));
	and_gate andslt1 (.x(Op[0]), .y(Op[2]), .z(t6));
  not_gate not_slt (.x(Op[1]), .z(t8));
  and_gate and_slt3 (.x(t8), .y(t6), .z(t9));
	and_gate andslt2 (.x(t9), .y(t_slt0), .z(t_slt));
	
	//set sltu
	not_gate not_sltu (.x(Carryout), .z(t_sltu0));
	and_gate andsltu1 (.x(Op[1]), .y(Op[2]), .z(t7));
  not_gate not_sltu1 (.x(Op[0]), .z(t10));
  and_gate and_sltu3 (.x(t10), .y(t7), .z(t11));
	and_gate andsltu2 (.x(t11), .y(t_sltu0), .z(t_sltu));

  or_gate orset (.x(t_slt), .y(t_sltu),  .z(Set));	
	

	

  
endmodule
