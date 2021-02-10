module CPU(clk, initPC, nextPC, currentPC_if, inst_id, wDin, rs1_id, rs2_id, Memread, shamt, funct, immed, ALUSrc, MemtoReg, RegWrite, MemWrite, should_branch_id, Extop,ALUop,Result,alu_input, alu_control);
   // Wires and Registers are (or should be) suffixed with the stage they origininate from, or the receiving stage of the interstage registers (where it's used) 
   //   If a component also acts as the inter stage register, the outputs are considered to be in the next stage.
   parameter file_name="../data/unsigned_sum.dat";
   //parameter file_name="data/bills_branch.dat";
   //parameter file_name = "data/sort_corrected_branch.dat";
   input clk;
   input initPC;
   output [31:0] nextPC, currentPC_if, wDin, rs1_id, rs2_id, Memread;
   output [0:31] inst_id;
   output [4:0]  shamt;
   output [5:0]  funct;
   wire [5:0] 	 opcode_if, funct_if, opcode_ex;
   output [0:15] immed;
   reg [0:15] 	 immed_ex;
   wire [0:15] 	 immed_id;
   output wire 	 MemtoReg, RegWrite, MemWrite, should_branch_id, Extop;
   wire 	 MemtoReg_id, MemtoReg_wb, RegWrite_id, RegWrite_wb, MemWrite_id, Extop_id;
   output wire 	 ALUSrc;
   output wire [1:0] ALUop;
   wire 	     ALUSrc_id;
   wire [3:0] 	     ALUop_id;
   wire [4:0] 	     towrite, RegDst_mem, RegDst_wb;
   wire [31:0] 	     se_immed;
   output wire [31:0] alu_input; 
   wire [31:0] 	      alu_input_new;
   output wire [3:0]  alu_control;
   wire 	      Branch_ex;
   wire 	      MemtoReg_mem, RegWrite_mem;
   wire 	      Carryout, Overflow, Zero, Set;
   output wire [31:0] Result;
   wire [31:0] 	      alu_result_mem, alu_result_ex, result_wb, Result_ex, mem_data_mem;
   wire [31:0] 	      data_wb, mem_store_data_mem;
   wire 	      lw_stall, lw_stall_id,Branch_taken,init_delay,Branch_stall_forwarding,initPC_delay4,initPC_delay6,valid;
   wire 	      kill_next_instruction_id, should_be_killed_id, stall_id;
   wire [31:0] 	      new_pc_if_jump_id, rs1_id_preforward;
   reg [31:0] 	      pcPlusFour_id;

   reg RegWrite_ex, Extop_ex, ALUSrc_ex, MemWrite_ex, MemtoReg_ex;
   reg [3:0] ALUop_ex;
   reg [4:0] RegDst_ex, rs1_sel_ex, rs2_sel_ex;
   reg [31:0] pcPlusFour_ex, rs1_ex, rs2_ex;
   //wire [4:0] towrite_delay;
   // initialize or nextPC
   PC pc (.clk(clk), .CurrPC(currentPC_if), .Branch(should_branch_id), .BranchPC(new_pc_if_jump_id), .stall(stall_id), .NextPC(currentPC_if));
   always @(negedge clk) begin
      pcPlusFour_id <= currentPC_if + 4;
   end
   
   // instruction fetch
   //  Updates instr_if at negedge of clock. That means inst is considered after the IF/ID register, so I suffixed the output with _id.
   IF_stage cpu_if0 (.clk(clk), .PC(currentPC_if), .instr_if(inst_id));
   defparam cpu_if0.inst_name = file_name;
   
   //instruction decode
   // Honestly I don't think we need this at all anymore
   // ID_stage cpu_id (.clk(clk), .opcode(opcode), .opcode_if(opcode_if), .rs(rs), .rt(rt), .rd(rd), .shamt(shamt), .funct(funct), 
   //                  .funct_if(funct_if), .instr_if(inst_id), .immi(immed), .lw_stall(lw_stall), .lw_stall_id(lw_stall_id));
   wire [0:4] rs1_sel_id, rs2_sel_id;
   wire [4:0] RegDst_id;
   assign rs1_sel_id = inst_id[6:10];
   assign immed_id = inst_id[16:31];
   
   // Control Signal
   // Combinational logic right now
   control ctrl (.instr(inst_id), .rs1(rs1_id), .rs2_sel(rs2_sel_id), .pc_plus_four(pcPlusFour_id), .should_be_killed(should_be_killed_id), .RegWr(RegWrite_id),
		 .RegDst(RegDst_id), .ExtOp(Extop_id), .AluSrc(ALUSrc_id), .AluOp(ALUop_id), .Branch(should_branch_id), .MemWr(MemWrite_id), 
		 .MemToReg(MemtoReg_id), .new_pc_if_jump(new_pc_if_jump_id), .kill_next_instruction(kill_next_instruction_id), .stall(stall_id));
   dff kill (.clk(clk), .d(kill_next_instruction_id), .q(should_be_killed_id));

   // TODO: make sure rs1 contains the correct forwarded value for the branch control
                   // forward from the EX stage if the destination of the output is this register
   		   // Note we shouldn't need to worry about a lw in the execution stage 
                   //    (which would not yet have the loaded value at that point) because of the stall and killed instruction
   assign rs1_id = (rs1_sel_id === RegDst_ex)  && (RegWrite_ex) ? alu_result_ex // 
		   : // Forward from the MEM stage -- need to determine if it's the alu_result or the value from memory
  		   (rs1_sel_id === RegDst_mem) && (RegWrite_mem) 
		     ? 
		   (MemtoReg_mem ? mem_data_mem : alu_result_mem) 
		       : rs1_id_preforward;
								    
   // RegisterFiles
   // Looks like it's combinational for the read, so it should be passed in a dff to ex stage? 
   RegisterFiles cpu_rf (.clk(clk), .writenable(RegWrite_wb), .rs1_sel(rs1_sel_id), .rs2_sel(rs2_sel_id), .writesel(RegDst_wb), .Din(data_wb), .rs1_out(rs1_id_preforward), .rs2_out(rs2_id));
   

   // Basically dffs to act as the ID/EX registers
   always @(negedge clk) begin
      pcPlusFour_ex <= pcPlusFour_id;
      RegWrite_ex <= RegWrite_id;
      RegDst_ex <=  RegDst_id;
      Extop_ex <= Extop_id;
      ALUSrc_ex <= ALUSrc_id;
      ALUop_ex <= ALUop_id;
      MemWrite_ex <= MemWrite_id;
      MemtoReg_ex <= MemtoReg_id;
      rs1_ex <= rs1_id;
      rs2_ex <= rs2_id;
      // Needed to handle forwarding
      rs1_sel_ex <= rs1_sel_id;
      rs2_sel_ex <= rs2_sel_id;
      immed_ex <= immed_id;
   end
  
   // sign extend the immed
   // Combinational
   // assign se_immed = Extop_ex == 1 ?
		     //	{ {16 { immed_ex[1] } }, immed_ex[0:15] } :
		     // { {16 { 1'b0        } }, immed_ex[0:15] };
   Signextend cpu_se (.Extop(Extop_ex), .Din(immed_ex), .Dout(se_immed));
   
   // Mux rs2 or immediate to get B for ALU
   // Looks like we don't worry about shamt in DLX, it's only either rs1 or the immediate as possibilites for the input
   mux_32 cpu_mux0 (.sel(ALUSrc), .src0(rs2_ex), .src1(se_immed), .z(alu_input_new));
   // mux_32 cpu_mux4 (.sel(ALUSrc[1]), .src0(alu_input_new), .src1({27'b0, shamt}), .z(alu_input));
   // ALU control signal. Don't think we need this anymore
   ALUctrl cpu_A (.ALUop(ALUop), .funct(funct), .Control(alu_control));
   // Execution
   // I dont think we need:
   //   valid, 
   //   initPC-delays
   // Looks like the *_ex signals are actually the outputs of the stage that are meant to be passed on. Above this I followed the opposite convention, _ex means it's used in EX stage
   //   TODO: Update this to reflect the conventions used above
   //   TODO: Update to remove the signals we don't need (valid, branch, delay, lw_stall, immed, immed_ex, etc)
   //   TODO: Confirm which each of these inputs are for. is mem_data the data to be placed in memory in the next stage, or the data from the memory from the MEM stage?
   EX_stage cpu_ex (.clk(clk), .A(rs1_ex), .B(alu_input_new), .Op_ex(ALUop_ex), .Carryout(Carryout), .Overflow(Overflow), .Zero(Zero), .Result_ex(alu_result_ex), .Result_mem(alu_result_mem), 
		    .Set(Set), // .immed(immed), .immed_ex(immed_ex), .opcode(opcode), .opcode_ex(opcode_mem), .Branch(should_branch_id), 
		    .MemtoReg_ex(MemtoReg_ex), .RegWrite_ex(RegWrite_ex),.MemWrite_ex(MemWrite_ex), .towrite(RegDst_ex), .Branch_ex(Branch_ex), .MemtoReg_mem(MemtoReg_mem), 
		    .RegWrite_mem(RegWrite_mem),.MemWrite_mem(MemWrite_mem), .towrite_ex(RegDst_mem), 
		    .mem_data(rs2_ex), .mem_data_ex(mem_store_data_mem), // rs2 is technically rd in i type (sw) aka the stored value
                    .rs(rs1_sel_ex),.rt(rs2_sel_ex), .ALUSrc(ALUSrc), .towrite_mem(RegDst_mem), .valid(valid),
                    .lw_stall_id(lw_stall_id),.Branch_stall_forwarding(Branch_stall_forwarding), .initPC_delay4(initPC_delay4),.initPC_delay6(initPC_delay6));//for forwarding  

   
								    
   //data memory
   Mem_stage cpu_mem (.clk(clk),.cs(1'b1),.oe(1'b1),.we(MemWrite_mem),.addr(alu_result_mem),.din(mem_store_data_mem),.dout(Memread), .dout_mem(mem_data_mem), .result_mem(result_wb), 
                      .MemtoReg_ex(MemtoReg_mem), .RegWrite_ex(RegWrite_mem),.MemtoReg_mem(MemtoReg_wb), .RegWrite_mem(RegWrite_wb),
                      .towrite_ex(RegDst_mem),.towrite_mem(RegDst_wb), .Branch_ex(Branch_taken),.init_delay(init_delay),.Branch_stall_forwarding(Branch_stall_forwarding));
   defparam cpu_mem.mem_file = file_name;
   // write back
   // Literally Just a mux to determine which data gets written back
   WB_stage cpu_wb (.MemtoReg(MemtoReg_wb), .Result(result_wb), .Memread(Memread), .wDin(data_wb));
endmodule

  
  
  
  
