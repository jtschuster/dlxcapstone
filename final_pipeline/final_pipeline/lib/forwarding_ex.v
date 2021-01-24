module forwarding_ex (clk,rs,rt,ALUSrc,towrite_ex,towrite_mem, result, result_mem, A, B, opA, opB, lw_stall_ex,Branch_stall_forwarding,sw_ex,sw_mem,Branch_ex);

  input clk;
  input [4:0] rs, rt, towrite_ex, towrite_mem;
  input [1:0] ALUSrc; //ALUSrc = 2'b00 may exist forwarding for B
  input [31:0] A;
  input [31:0] B;
  input [31:0] result, result_mem;
  input lw_stall_ex,Branch_stall_forwarding,sw_ex,sw_mem,Branch_ex;
  output [31:0] opA;
  output [31:0] opB;
  wire [31:0] opB_tmp1, opB_tmp2, opA_lw,opB_lw,opA_new,opB_new,opA_tmp1,opB_tmp3;
  wire [4:0] compareA_ex, compareB_ex;
  wire [4:0] compareA_mem, compareB_mem;
  wire w0_ex,w1_ex,w2_ex,r0_ex,r1_ex,r2_ex,w0_mem,w1_mem,w2_mem,r0_mem,r1_mem,r2_mem,sel_A_ex,sel_B_ex,sel_A_mem,sel_B_mem;
  wire lw_stall_delay,sel_A_ex_pre,sel_B_ex_pre,sel_A_mem_pre,sel_B_me_pre,ex,mem,Branch_mem_forwarding;
  wire [31:0] result_A, result_B;



  generate 
  genvar j;
  for (j=0; j < 5; j = j + 1)
	begin
        xor_gate A_compare_ex (.x(rs[j]), .y(towrite_ex[j]), .z(compareA_ex[j]));
        xor_gate B_compare_ex (.x(rt[j]), .y(towrite_ex[j]), .z(compareB_ex[j]));
	end
  endgenerate
  generate 
  genvar i;
  for (i=0; i < 5; i = i + 1)
	begin
        xor_gate A_compare_mem (.x(rs[i]), .y(towrite_mem[i]), .z(compareA_mem[i]));
        xor_gate B_compare_mem (.x(rt[i]), .y(towrite_mem[i]), .z(compareB_mem[i]));
	end
  endgenerate



  or_gate A_or_gate0_ex (.x(compareA_ex[0]), .y(compareA_ex[1]), .z(w0_ex));
  or_gate A_or_gate1_ex (.x(compareA_ex[2]), .y(w0_ex), .z(w1_ex));
  or_gate A_or_gate2_ex (.x(compareA_ex[3]), .y(w1_ex), .z(w2_ex));
  or_gate A_or_gate3_ex (.x(compareA_ex[4]), .y(w2_ex), .z(sel_A_ex_pre));

  or_gate B_or_gate0_ex (.x(compareB_ex[0]), .y(compareB_ex[1]), .z(r0_ex));
  or_gate B_or_gate1_ex (.x(compareB_ex[2]), .y(r0_ex), .z(r1_ex));
  or_gate B_or_gate2_ex (.x(compareB_ex[3]), .y(r1_ex), .z(r2_ex));
  or_gate B_or_gate3_ex (.x(compareB_ex[4]), .y(r2_ex), .z(sel_B_ex_pre));
  //sw_ex no need to forwarding
  or_gate or_gate4_ex (.x(sw_ex), .y(Branch_ex), .z(ex));

  mux mux_A_sw1 (.sel(ex), .src0(sel_A_ex_pre), .src1(1'b1), .z(sel_A_ex));
  mux mux_B_sw1 (.sel(ex), .src0(sel_B_ex_pre), .src1(1'b1), .z(sel_B_ex));

  or_gate A_or_gate0_mem (.x(compareA_mem[0]), .y(compareA_mem[1]), .z(w0_mem));
  or_gate A_or_gate1_mem (.x(compareA_mem[2]), .y(w0_mem), .z(w1_mem));
  or_gate A_or_gate2_mem (.x(compareA_mem[3]), .y(w1_mem), .z(w2_mem));
  or_gate A_or_gate3_mem (.x(compareA_mem[4]), .y(w2_mem), .z(sel_A_mem_pre));

  or_gate B_or_gate0_mem (.x(compareB_mem[0]), .y(compareB_mem[1]), .z(r0_mem));
  or_gate B_or_gate1_mem (.x(compareB_mem[2]), .y(r0_mem), .z(r1_mem));
  or_gate B_or_gate2_mem (.x(compareB_mem[3]), .y(r1_mem), .z(r2_mem));
  or_gate B_or_gate3_mem (.x(compareB_mem[4]), .y(r2_mem), .z(sel_B_mem_pre));
  //sw_mem no need to forwarding
  dff reg_branch_mem (.clk(clk), .d(Branch_ex), .q(Branch_mem_forwarding));
  
  or_gate or_gate4_mem (.x(sw_mem), .y(Branch_mem_forwarding), .z(mem));
  mux mux_A_sw2 (.sel(mem), .src0(sel_A_mem_pre), .src1(1'b1), .z(sel_A_mem));
  mux mux_B_sw2 (.sel(mem), .src0(sel_B_mem_pre), .src1(1'b1), .z(sel_B_mem));

  //fow add
  mux mux_A (.sel(sel_A_ex), .src0(sel_A_ex), .src1(sel_A_mem), .z(sel_A));
  mux mux_B (.sel(sel_B_ex), .src0(sel_B_ex), .src1(sel_B_mem), .z(sel_B));
  mux_32 mux_resultA0 (.sel(sel_A_ex), .src0(result), .src1(result_mem), .z(result_A));
  mux_32 mux_resultB0 (.sel(sel_B_ex), .src0(result), .src1(result_mem), .z(result_B));

  mux_32 mux_32_A (.sel(sel_A), .src0(result_A), .src1(A), .z(opA_new));
  mux_32 mux_32_B (.sel(sel_B), .src0(result_B), .src1(B), .z(opB_tmp1));

  //for lw
  mux_32 mux_resultA1 (.sel(sel_A_mem), .src0(result_mem), .src1(A), .z(opA_lw));
  mux_32 mux_resultB1 (.sel(sel_B_mem), .src0(result_mem), .src1(B), .z(opB_lw));
  //final A,B 
  mux_32 mux_lw0 (.sel(lw_stall_ex), .src0(opA_new), .src1(opA_lw), .z(opA_tmp1));
  mux_32 mux_lw1 (.sel(lw_stall_ex), .src0(opB_tmp1), .src1(opB_lw), .z(opB_new));
  //forwarding stall for branch
  mux_32 mux_branch0 (.sel(Branch_stall_forwarding), .src0(opA_tmp1), .src1(A), .z(opA));
  mux_32 mux_branch1 (.sel(Branch_stall_forwarding), .src0(opB_new), .src1(B), .z(opB_tmp3));

  mux_32 mux_32_ALUSrc1 (.sel(ALUSrc[0]), .src0(opB_tmp3), .src1(B), .z(opB_tmp2));
  mux_32 mux_32_ALUSrc2 (.sel(ALUSrc[1]), .src0(opB_tmp2), .src1(B), .z(opB));
endmodule
