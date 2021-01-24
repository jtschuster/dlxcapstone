module alu (A, B, Op, Carryout, Overflow, Zero, Result, Set);
  input [31:0] A;
  input [31:0] B;
  input [3:0] Op;
  output  Carryout;
  output  Overflow;
  output  Zero;
  output [31:0] Result;
  output Set;
  wire Carryout_andsub;
  wire Carryout_sll;
  wire Carryout_srl;
  wire Overflow_andsub;
  wire Overflow_sll;
  wire Overflow_srl;
  wire [31:0] Result_andsub;
  wire [31:0] Result_sll;
  wire [31:0] Result_srl;
  wire [31:0] t_andsub;
  wire [31:0] t_sll;
  wire [31:0] t_srl;
  wire t1;
  wire t2;
  wire t3;
  wire [31:0] t4;  
  wire  t5;
  wire  t6;
  wire  t7;
  wire z1,z2,z3,z4,z5,z6,z7,z8,z9,z10,z11,z12,z13,z14,z15,z16,z17,z18,z19,z20,z21,z22,z23,z24,z25,z26,z27,z28,z29,z30,z31;
  sll sll_instance (.A(A), .B(B), .Op(Op), .Carryout(Carryout_sll), .Overflow(Overflow_sll),  .Result(Result_sll));
  srl srl_instance (.A(A), .B(B), .Op(Op), .Carryout(Carryout_srl), .Overflow(Overflow_srl),  .Result(Result_srl));
  alu_32 andsub (.A(A), .B(B), .Op(Op), .Carryout(Carryout_andsub), .Overflow(Overflow_andsub), .Final_result(Result_andsub), .Set(Set));
  
//select result  
    and_gate andsll1 (.x(Op[3]),.y(Op[0]), .z(t1));
	and_gate andsrl1 (.x(Op[3]),.y(Op[1]), .z(t2));
	not_gate notop3 (.x(Op[3]), .z(t3));

    mux_32 mux1 (.sel(Op[3]), .src0(Result_andsub), .src1(Result_sll), .z(t4));
	mux_32 mux2 (.sel(t2), .src0(t4), .src1(Result_srl), .z(Result));
	

	
//overflow
	
	and_gate andover (.x(t3), .y(Overflow_andsub), .z(Overflow));
	and_gate andcarry (.x(t3), .y(Carryout_andsub), .z(Carryout));
	
//zero
	or_gate orz1(.x(Result[0]), .y(Result[1]), .z(z1));
	or_gate orz2(.x(z1), .y(Result[2]), .z(z2));
	or_gate orz3(.x(z2), .y(Result[3]), .z(z3));
	or_gate orz4(.x(z3), .y(Result[4]), .z(z4));
	or_gate orz5(.x(z4), .y(Result[5]), .z(z5));
	or_gate orz6(.x(z5), .y(Result[6]), .z(z6));
	or_gate orz7(.x(z6), .y(Result[7]), .z(z7));
	or_gate orz8(.x(z7), .y(Result[8]), .z(z8));
	or_gate orz9(.x(z8), .y(Result[9]), .z(z9));
	or_gate orz10(.x(z9), .y(Result[10]), .z(z10));
	or_gate orz11(.x(z10), .y(Result[11]), .z(z11));
	or_gate orz12(.x(z11), .y(Result[12]), .z(z12));
	or_gate orz13(.x(z12), .y(Result[13]), .z(z13));
	or_gate orz14(.x(z13), .y(Result[14]), .z(z14));
	or_gate orz15(.x(z14), .y(Result[15]), .z(z15));
	or_gate orz16(.x(z15), .y(Result[16]), .z(z16));
	or_gate orz17 (.x(z16), .y(Result[17]), .z(z17));
	or_gate orz18 (.x(z17), .y(Result[18]), .z(z18));
	or_gate orz19 (.x(z18), .y(Result[19]), .z(z19));
	or_gate orz20 (.x(z19), .y(Result[20]), .z(z20));
	or_gate orz21(.x(z20), .y(Result[21]), .z(z21));
	or_gate orz22(.x(z21), .y(Result[22]), .z(z22));
	or_gate orz23(.x(z22), .y(Result[23]), .z(z23));
	or_gate orz24(.x(z23), .y(Result[24]), .z(z24));
	or_gate orz25(.x(z24), .y(Result[25]), .z(z25));
	or_gate orz26(.x(z25), .y(Result[26]), .z(z26));
	or_gate orz27(.x(z26), .y(Result[27]), .z(z27));
	or_gate orz28(.x(z27), .y(Result[28]), .z(z28));
	or_gate orz29(.x(z28), .y(Result[29]), .z(z29));
	or_gate orz30(.x(z29), .y(Result[30]), .z(z30));
	or_gate orz31(.x(z30), .y(Result[31]), .z(z31));
	
	not_gate zero(.x(z31), .z(Zero));
	


  
endmodule

