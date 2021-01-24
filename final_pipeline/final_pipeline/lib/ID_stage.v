module ID_stage (clk, opcode,opcode_if, rs, rt, rd, shamt, funct, funct_if,instr_if, immi, lw_stall,lw_stall_id);//RegDst_id, ALUSrc_id, MemtoReg_id, RegWrite_id,
                 //MemWrite_id, Extop_id, ALUop_id, RegDst, ALUSrc, MemtoReg, RegWrite,
                 //MemWrite, Extop, ALUop);
  input clk;
  input [31:0] instr_if;
  //input RegDst_id, MemtoReg_id, RegWrite_id, MemWrite_id, Extop_id;
  //output RegDst, MemtoReg, RegWrite, MemWrite, Extop;
  //input [1:0] ALUSrc_id;
  //input [1:0] ALUop_id;
  //output [1:0] ALUSrc;
  //output [1:0] ALUop;
  output [5:0] opcode,opcode_if;
  output [4:0] rs;
  output [4:0] rt;
  output [4:0] rd;
  output [4:0] shamt;
  output [5:0] funct, funct_if; 
  output [15:0] immi;
  output lw_stall,lw_stall_id;
  wire [31:0] instr_id;
  wire [5:0] NotOp;
  generate 
  genvar index;
  for (index=0; index < 32; index = index + 1)
	begin
        dff reg32_instr_id (.clk(clk), .d(instr_if[index]), .q(instr_id[index]));
	end
  endgenerate
  /*
  dff reg_RegDst (.clk(clk), .d(RegDst_id), .q(RegDst));
  dff reg_RegWrite (.clk(clk), .d(RegWrite_id), .q(RegWrite));
  dff reg_MemtoReg (.clk(clk), .d(MemtoReg_id), .q(MemtoReg));
  dff reg_MemWrite (.clk(clk), .d(MemWrite_id), .q(MemWrite));
  dff reg_Extop (.clk(clk), .d(Extop_id), .q(Extop));
  dff reg_ALUSrc0 (.clk(clk), .d(ALUSrc_id[0]), .q(ALUSrc[0]));
  dff reg_ALUSrc1 (.clk(clk), .d(ALUSrc_id[1]), .q(ALUSrc[1]));
  dff reg_ALUop0 (.clk(clk), .d(ALUop_id[0]), .q(ALUop[0]));
  dff reg_ALUop1 (.clk(clk), .d(ALUop_id[1]), .q(ALUop[1]));
  */
  assign opcode = instr_id[31:26];
  assign opcode_if = instr_if[31:26];
  assign rs = instr_id[25:21];
  assign rt = instr_id[20:16];
  assign rd = instr_id[15:11];
  assign shamt = instr_id[10:6];
  assign funct = instr_id[5:0];
  assign func_if = instr_if[5:0];
  assign immi = instr_id[15:0];
//lw forwarding stall judgement
  not_gate_n #(.n(6)) csnotg0 (.x(opcode_if), .z(NotOp));
  and_6 csand4 (.a(opcode_if[5]), .b(NotOp[4]), .c(NotOp[3]),.d(NotOp[2]),.e(opcode_if[1]),.f(opcode_if[0]),.z(lw_stall));
  dff reg_lw_stall_id (.clk(clk), .d(lw_stall), .q(lw_stall_id));
endmodule
