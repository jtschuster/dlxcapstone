module sll (A, B, Op, Carryout, Overflow, Result);
  input [31:0] A;
  input [31:0] B;
  input [3:0] Op;
  output wire Carryout;
  output wire Overflow;
  output wire [31:0] Result;
  wire [30:0] extend;
  wire [31:0] S0;
  wire [31:0] S0_out;
  wire [31:0] S1;
  wire [31:0] S1_out;
  wire [31:0] S2;
  wire [31:0] S2_out;
  wire [31:0] S3;
  wire [31:0] S3_out;
  wire [31:0] S4;
  

  //assign S0={A[30:0],1'b0};
  or_gate_32 ors0 (.x({A[30:0],1'b0}), .y(32'h0), .z(S0));  
  mux_32 mux_1 (.sel(B[0]), .src0(A), .src1(S0), .z(S0_out));
  
  //assign S1={S0[29:0],2'b0};
  or_gate_32 ors1 (.x({S0_out[29:0],2'b0}), .y(32'h0), .z(S1));  
  mux_32 mux_2 (.sel(B[1]), .src0(S0_out), .src1(S1), .z(S1_out));
  
  //assign S2={S1[27:0],4'b0};
  or_gate_32 ors2 (.x({S1_out[27:0],4'b0}), .y(32'h0), .z(S2)); 
  mux_32 mux_3 (.sel(B[2]), .src0(S1_out), .src1(S2), .z(S2_out));
  
  //assign S3={S2[23:0],8'b0};
  or_gate_32 ors3 (.x({S2_out[23:0],8'b0}), .y(32'h0), .z(S3));
  mux_32 mux_4 (.sel(B[3]), .src0(S2_out), .src1(S3), .z(S3_out));
  
  //assign S4={S3[15:0],16'b0};
  or_gate_32 ors4 (.x({S3_out[15:0],16'b0}), .y(32'h0), .z(S4));
  mux_32 mux_5 (.sel(B[4]), .src0(S3_out), .src1(S4), .z(Result));
  
  
  
 
  
  

  
  
  and_gate andcarry (.x(1'b0), .y(1'b0), .z(Carryout));
  and_gate andOverflow (.x(1'b0), .y(1'b0), .z(Overflow));
  //assign Carryout=1'b0;
  //assign Overflow=1'b0;
   
endmodule
