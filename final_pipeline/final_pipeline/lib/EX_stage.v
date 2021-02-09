module EX_stage (clk, A, B, Op, Carryout, Overflow, Zero, Result, result_mem, Set, immed, immed_ex,opcode,opcode_ex, Branch, 
                 MemtoReg, RegWrite, MemWrite, Branch_ex,MemtoReg_ex, RegWrite_ex, MemWrite_ex,towrite,towrite_ex,towrite_mem, 
                 mem_data, mem_data_ex,rs,rt,ALUSrc,lw_stall_id,Branch_stall_forwarding,initPC_delay4,initPC_delay6,valid);
  input clk, lw_stall_id;
  input [31:0] A;
  input [31:0] B;
  input [31:0] mem_data, result_mem;
  input [15:0] immed;
  output [15:0] immed_ex;
  input [5:0] opcode;
  output [5:0] opcode_ex;
  input [3:0] Op;
  input [4:0] towrite, towrite_mem;
  input [4:0] rs, rt;
  input [1:0] ALUSrc;
  input MemWrite, MemtoReg, RegWrite,Branch,Branch_stall_forwarding,initPC_delay4,initPC_delay6;
  output [4:0] towrite_ex;
  output MemWrite_ex, MemtoReg_ex, RegWrite_ex,Branch_ex;
  output  Carryout;
  output  Overflow;
  output  Zero;
  output [31:0] Result;
  output Set,valid;
  output [31:0] mem_data_ex;
  wire  Carryout_tmp;
  wire  Overflow_tmp;
  wire [5:0] opcode_mem,NotOp_ex,NotOp_mem;
  wire  Zero_tmp;
  wire [31:0] Result_tmp,opA,opB;
  wire Set_tmp, lw_stall_ex, lw_stall_delay,sw_ex,sw_mem,sw_ex_new,sw_mem_new,sw_mem_new2;  

  forwarding_ex forwarding_ex (.clk(clk),.rs(rs),.rt(rt), .ALUSrc(ALUSrc), .towrite_ex(towrite_ex), .towrite_mem(towrite_mem), 
                               .result(Result), .result_mem(result_mem), .A(A), .B(B), .opA(opA), .opB(opB),.lw_stall_ex(lw_stall_delay),
                               .Branch_stall_forwarding(Branch_stall_forwarding), .sw_ex(sw_ex_new), .sw_mem(sw_mem_new2),.Branch_ex(Branch_ex));



  alu cpu_alu (.A(opA), .B(opB), .Op(Op), .Carryout(Carryout_tmp), .Overflow(Overflow_tmp), .Zero(Zero_tmp), .Result(Result_tmp), .Set(Set_tmp));
  generate 
  genvar index;
  for (index=0; index < 32; index = index + 1)
	begin
        dff reg32_Ex (.clk(clk), .d(Result_tmp[index]), .q(Result[index]));
        dff reg32_mem_data (.clk(clk), .d(mem_data[index]), .q(mem_data_ex[index]));
	end
  endgenerate
  dff reg_carryout (.clk(clk), .d(Carryout_tmp), .q(Carryout));
  dff reg_Overflow (.clk(clk), .d(Overflow_tmp), .q(Overflow));
  dff reg_Zero (.clk(clk), .d(Zero_tmp), .q(Zero));
  dff reg_Set (.clk(clk), .d(Set_tmp), .q(Set));
  //control signal fetch  dff reg_MemWrite (.clk(clk), .d(MemWrite), .q(MemWrite_ex));
  dff reg_MemtoReg (.clk(clk), .d(MemtoReg), .q(MemtoReg_ex));
  dff reg_RegWrite (.clk(clk), .d(RegWrite), .q(RegWrite_ex));
  dff reg_Branch (.clk(clk), .d(Branch), .q(Branch_ex));
  dff reg_lw_stall_ex (.clk(clk), .d(lw_stall_id), .q(lw_stall_ex));
  dff reg_lw_stall_delay (.clk(clk), .d(lw_stall_ex), .q(lw_stall_delay));
  generate 
  genvar i;
  for (i=0; i < 5; i = i + 1)
	begin
        dff reg_towrite (.clk(clk), .d(towrite[i]), .q(towrite_ex[i]));
        dff reg_opcode0 (.clk(clk), .d(opcode[i]), .q(opcode_ex[i]));
        dff reg_opcode2 (.clk(clk), .d(opcode_ex[i]), .q(opcode_mem[i]));
	end
  endgenerate
  dff reg_opcode3 (.clk(clk), .d(opcode[5]), .q(opcode_ex[5]));
  dff reg_opcode4 (.clk(clk), .d(opcode_ex[5]), .q(opcode_mem[5]));
  not_gate_n #(.n(6)) not0 (.x(opcode_ex), .z(NotOp_ex));
  not_gate_n #(.n(6)) not1 (.x(opcode_mem), .z(NotOp_mem));
  and_6 csand4 (.a(opcode_ex[5]), .b(NotOp_ex[4]), .c(opcode_ex[3]),.d(NotOp_ex[2]),.e(opcode_ex[1]),.f(opcode_ex[0]),.z(sw_ex));
  and_6 csand5 (.a(opcode_mem[5]), .b(NotOp_mem[4]), .c(opcode_mem[3]),.d(NotOp_mem[2]),.e(opcode_mem[1]),.f(opcode_mem[0]), .z(sw_mem));
  not_gate not2 (.x(initPC_delay4), .z(NotinitPC_delay4));
  not_gate not3 (.x(initPC_delay6), .z(NotinitPC_delay6));
  and_gate and0 (.x(sw_ex), .y(NotinitPC_delay4), .z(sw_ex_new));
  and_gate and1 (.x(sw_mem), .y(NotinitPC_delay6), .z(sw_mem_new));
  and_gate and2 (.x(sw_mem_new), .y(NotinitPC_delay4), .z(sw_mem_new2));
  generate 
  genvar j;
  for (j=0; j < 16; j = j + 1)
	begin
        dff reg_immed (.clk(clk), .d(immed[j]), .q(immed_ex[j]));
	end
  endgenerate
wire invZero, valid_beyond, valid_bgtz, valid_zero;
//whether the output is valid
not_gate not_pc0 (.x(Zero_tmp),.z(invZero));
xnor_gate xnor_pc0 (.x(Result_tmp[31]),.y(Overflow_tmp),.z(valid_beyond));
and_gate and_bgtz (.x(valid_beyond), .y(invZero), .z(valid_bgtz));

// generate final valid signal for branch;
//whether the result is zero and whether the result is legal
mux mux_0 (.sel(opcode[0]), .src0(Zero_tmp), .src1(invZero), .z(valid_zero));
mux mux_1 (.sel(opcode[1]), .src0(valid_zero), .src1(valid_bgtz), .z(valid));
//and_gate and_0 (.x(Branch), .y(valid), .z(sel));




endmodule
