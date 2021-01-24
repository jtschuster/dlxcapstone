module Control(clk, Opcode, funct, RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, Branch, Extop, ALUop,valid);
  input clk,valid;
  input [5:0] Opcode;
  input [5:0] funct;
  output RegDst, Branch, MemWrite, MemtoReg, RegWrite, Extop;
  output [1:0] ALUSrc;
  output [1:0] ALUop;
  wire [1:0] temp;
  wire [5:0] NotOp;
  wire Rtype, addi_as, lw_as, sw_as, beq_br, bne_br, is_sll, Branch1,Branch2,Branch3,Branch2_new,Branch3_new, Branch_pre,taken;
  wire [5:0] Notfunct;
  
  not_gate_n #(.n(6)) csnotg0 (.x(Opcode), .z(NotOp));
  not_gate_n #(.n(6)) csnotg8 (.x(funct), .z(Notfunct));
  and_6 csand0 (.a(NotOp[5]), .b(NotOp[4]), .c(NotOp[3]),.d(NotOp[2]),.e(NotOp[1]),.f(NotOp[0]),.z(Rtype));
  // RegDst
  assign RegDst = Rtype;
  
  // ALUSrc
  and_6 csand1 (.a(NotOp[5]), .b(NotOp[4]), .c(Opcode[3]),.d(NotOp[2]),.e(NotOp[1]),.f(NotOp[0]),.z(addi_as));
  and_6 csand2 (.a(Opcode[5]), .b(NotOp[4]), .c(NotOp[3]),.d(NotOp[2]),.e(Opcode[1]),.f(Opcode[0]),.z(lw_as));
  and_6 csand3 (.a(Opcode[5]), .b(NotOp[4]), .c(Opcode[3]),.d(NotOp[2]),.e(Opcode[1]),.f(Opcode[0]),.z(sw_as));
  assign ALUSrc[0] = addi_as | lw_as | sw_as;
  and_6 csand9 (.a(Notfunct[0]), .b(Notfunct[4]), .c(Notfunct[3]),.d(Notfunct[2]),.e(Notfunct[1]),.f(Notfunct[0]),.z(is_sll));
  and_gate cdang0 (.x(is_sll), .y(Rtype), .z(ALUSrc[1]));
  
  
  assign MemtoReg = lw_as;
  assign RegWrite = Rtype | addi_as | lw_as;
  assign MemWrite = sw_as;
  and_6 csand4 (.a(NotOp[5]), .b(NotOp[4]), .c(NotOp[3]),.d(Opcode[2]),.e(NotOp[1]),.f(NotOp[0]),.z(beq_br));
  and_6 csand5 (.a(NotOp[5]), .b(NotOp[4]), .c(NotOp[3]),.d(Opcode[2]),.e(NotOp[1]),.f(Opcode[0]), .z(bne_br));
  and_6 csand6 (.a(NotOp[5]), .b(NotOp[4]), .c(NotOp[3]),.d(Opcode[2]),.e(Opcode[1]),.f(Opcode[0]), .z(bgtz_br));
  assign Branch_pre = beq_br | bne_br | bgtz_br;
  and_gate and_0 (.x(Branch_pre), .y(valid), .z(taken));

  //cancle the branch if the branch is in the previous branch_stall
  dff reg_Branch1 (.clk(clk), .d(taken), .q(Branch1));
  dff reg_Branch2 (.clk(clk), .d(Branch1), .q(Branch2));
  dff reg_Branch3 (.clk(clk), .d(Branch2), .q(Branch3));
  or_gate Branch_cancle1 (.x(Branch1), .y(Branch2), .z(Branch2_new));
  or_gate Branch_cancle2 (.x(Branch2_new), .y(Branch3), .z(Branch3_new));
  mux mux_cancle (.sel(Branch3_new), .src0(Branch_pre), .src1(1'b0), .z(Branch));
  assign Extop = 1'b1;
  // ALUop
  mux_n #(.n(2)) csmux0 (.sel(Branch), .src0(2'b01), .src1(2'b10), .z(temp));
  mux_n #(.n(2)) csmux1 (.sel(RegDst), .src0(temp), .src1(2'b00), .z(ALUop));
 endmodule