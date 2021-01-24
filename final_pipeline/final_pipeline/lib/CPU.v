module CPU(clk, initPC, nextPC, regPC, inst, wDin, Dout1, Dout2, rt, rs, rd, Memread, shamt, opcode, funct, immed, RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, Branch, Extop,ALUop,Result,alu_input, alu_control);
  
  parameter file_name="data/unsigned_sum.dat";
  //parameter file_name="data/bills_branch.dat";
  //parameter file_name = "data/sort_corrected_branch.dat";
  input clk;
  input initPC;
  output [31:0] nextPC, regPC, inst, wDin, Dout1, Dout2, Memread;
  output [4:0] rt, rs, rd, shamt;
  output [5:0] opcode, funct;
  wire [5:0] opcode_if, funct_if, opcode_ex;
  output [15:0] immed;
  wire [15:0] immed_ex;
  output wire RegDst, MemtoReg, RegWrite, MemWrite, Branch, Extop;
  wire RegDst_id, MemtoReg_id, RegWrite_id, MemWrite_id, Extop_id;
  output wire [1:0] ALUSrc;
  output wire [1:0] ALUop;
  wire [1:0] ALUSrc_id;
  wire [1:0] ALUop_id;
  wire [4:0] towrite,towrite_ex,towrite_mem;
  wire [31:0] se_immed;
  output wire [31:0] alu_input; 
  wire [31:0] alu_input_new;
  output wire [3:0] alu_control;
  wire MemWrite_ex, MemtoReg_ex, RegWrite_ex,Branch_ex;
  wire MemtoReg_mem, RegWrite_mem;
  wire Carryout, Overflow, Zero, Set;
  output wire [31:0] Result;
  wire [31:0] result_mem;
  wire [31:0] mem_data_ex;
  wire lw_stall, lw_stall_id,Branch_taken,init_delay,Branch_stall_forwarding,initPC_delay4,initPC_delay6,valid;
  //wire [4:0] towrite_delay;
  // initialize or nextPC
  mux_32 cpu_mux2 (.sel(initPC),.src0(nextPC), .src1(32'h00400020), .z(regPC));
  
  // instruction fetch
  //  ifetch cpu_if0 (.PC(regPC), .opcode(opcode), .rs(rs), .rt(rt), .rd(rd), .shamt(shamt), .funct(funct), .instruction(inst), .immi(immed));
  IF_stage cpu_if0 (.clk(clk), .PC(regPC), .instr_if(inst));
  defparam cpu_if0.inst_name = file_name;

  //instruction decode
  ID_stage cpu_id (.clk(clk), .opcode(opcode), .opcode_if(opcode_if), .rs(rs), .rt(rt), .rd(rd), .shamt(shamt), .funct(funct), .funct_if(funct_if), .instr_if(inst), .immi(immed), 
                   .lw_stall(lw_stall), .lw_stall_id(lw_stall_id));
                   //.RegDst_id(RegDst_id), .ALUSrc_id(ALUSrc_id), .MemtoReg_id(MemtoReg_id), .RegWrite_id(RegWrite_id),
                   //.MemWrite_id(MemWrite_id), .Extop_id(Extop_id), .ALUop_id(ALUop_id), .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .RegWrite(RegWrite),
                   //.MemWrite(MemWrite), .Extop(Extop), .ALUop(ALUop));
  
  // opcode to control signal;
  Control cpu_c0 (.clk(clk), .Opcode(opcode), .funct(funct), .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .RegWrite(RegWrite),
					.MemWrite(MemWrite), .Branch(Branch), .Extop(Extop), .ALUop(ALUop),.valid(valid));
					
  // choose rd or rt based on RegDst
  mux_n #(.n(5)) cpu_m (.sel(RegDst), .src0(rt), .src1(rd), .z(towrite));
  /*
  generate 
  genvar index;
  for (index=0; index < 5; index = index + 1)
	begin
        dff reg32_towrite_delay (.clk(clk), .d(towrite[index]), .q(towrite_delay[index]));
	end
  endgenerate
  */
  // RegisterFiles
  RegisterFiles cpu_rf (.clk(clk), .writenable(RegWrite_mem), .readsel1(rs), .readsel2(rt), .writesel(towrite_mem), .Din(wDin), .Dout1(Dout1), .Dout2(Dout2));
  //registers cpu_rfn (.clk(clk), .writeEnable(RegWrite), .readReg1(rs), .readReg2(rt), .writeReg(towrite),.writeData(Din), .readData1(Dout1), .readData2(Dout2));
  // sign extend the immed
  Signextend cpu_se (.Extop(Extop), .Din(immed), .Dout(se_immed));
  // mux Dout2 or extended immed to ALU
  mux_32 cpu_mux0 (.sel(ALUSrc[0]), .src0(Dout2), .src1(se_immed), .z(alu_input_new));
  mux_32 cpu_mux4 (.sel(ALUSrc[1]), .src0(alu_input_new), .src1({27'b0, shamt}), .z(alu_input));
  // ALU control signal;
  ALUctrl cpu_A (.ALUop(ALUop), .funct(funct), .Control(alu_control));
  // Execution
  //alu cpu_alu (.A(Dout1), .B(alu_input), .Op(alu_control), .Carryout(Carryout), .Overflow(Overflow), .Zero(Zero), .Result(Result), .Set(Set));
  EX_stage cpu_ex (.clk(clk), .A(Dout1), .B(alu_input), .Op(alu_control), .Carryout(Carryout), .Overflow(Overflow), .Zero(Zero), .Result(Result), .Set(Set), .immed(immed), .immed_ex(immed_ex), .opcode(opcode), .opcode_ex(opcode_ex),
                   .Branch(Branch), .MemtoReg(MemtoReg), .RegWrite(RegWrite),.MemWrite(MemWrite), .towrite(towrite), .Branch_ex(Branch_ex), .MemtoReg_ex(MemtoReg_ex), .RegWrite_ex(RegWrite_ex),.MemWrite_ex(MemWrite_ex),
                   .towrite_ex(towrite_ex), .mem_data(Dout2), .mem_data_ex(mem_data_ex),
                   .rs(rs),.rt(rt),.ALUSrc(ALUSrc), .towrite_mem(towrite_mem),.result_mem(wDin),.valid(valid),
                   .lw_stall_id(lw_stall_id),.Branch_stall_forwarding(Branch_stall_forwarding), .initPC_delay4(initPC_delay4),.initPC_delay6(initPC_delay6));//for forwarding  
  //update PC;
  PC cpu_pc (.clk(clk), .initPC(initPC), .Branch(Branch_ex), .Zero(Zero), .Overflow(Overflow), .Op(opcode_ex), .Immed(immed_ex), 
			.ALUOutput(Result), .CurrPC(regPC), .NextPC(nextPC), .lw_stall(lw_stall), .sel(Branch_taken),.initPC_delay9(init_delay),
                        .initPC_delay4(initPC_delay4),.initPC_delay6(initPC_delay6));
  //data memory
  //syncram cpu_scm (.clk(clk),.cs(1'b1),.oe(1'b1),.we(MemWrite),.addr(Result),.din(Dout2),.dout(Memread));
  //defparam cpu_scm.mem_file = file_name;
  Mem_stage cpu_mem (.clk(clk),.cs(1'b1),.oe(1'b1),.we(MemWrite_ex),.addr(Result),.din(mem_data_ex),.dout(Memread), .result_mem(result_mem), 
                     .MemtoReg_ex(MemtoReg_ex), .RegWrite_ex(RegWrite_ex),.MemtoReg_mem(MemtoReg_mem), .RegWrite_mem(RegWrite_mem),
                     .towrite_ex(towrite_ex),.towrite_mem(towrite_mem), .Branch_ex(Branch_taken),.init_delay(init_delay),.Branch_stall_forwarding(Branch_stall_forwarding));
  defparam cpu_mem.mem_file = file_name;
  // write back
  //mux_32 cpu_mux1 (.sel(MemtoReg), .src0(Result), .src1(Memread), .z(wDin));
  WB_stage cpu_wb (.MemtoReg(MemtoReg_mem), .Result(result_mem), .Memread(Memread), .wDin(wDin));
endmodule
  
  
  
  
  
