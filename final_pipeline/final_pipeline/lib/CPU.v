module CPU(clk, currentPC_if, inst_id, rs1_id, rs2_id, Memread, ALUSrc, should_branch_id, alu_input);
   // Wires and Registers are (or should be) suffixed with the stage they origininate from, or the receiving stage of the interstage registers (where it's used) 
   //   If a component also acts as the inter stage register, the outputs are considered to be in the next stage.
   parameter file_name="../data/fib.dat";
   //parameter file_name="data/bills_branch.dat";
   //parameter file_name = "data/sort_corrected_branch.dat";
   input clk;
   reg [31:0] cycle_count;
   output [31:0] currentPC_if, rs2_id, Memread;
   output reg [31:0] rs1_id;
   reg [31:0] 	     rs1_ex, rs2_ex;
   output reg [0:31]     inst_id;
   wire [5:0] 	 opcode_if, funct_if, opcode_ex;
   reg [0:15] 	 immed_ex;
   wire [0:15] 	 immed_id;
   output wire 	 should_branch_id;
   wire 	 MemtoReg_id, MemtoReg_wb, RegWrite_id, RegWrite_wb, MemWrite_id, Extop_id;
   wire MemtoReg_wb_jal;
   output wire 	 ALUSrc;
   wire 	     ALUSrc_id;
   wire [4:0] 	     ALUop_id;
   wire [4:0] 	     towrite, RegDst_mem, RegDst_wb, RegDst_wb_jal;
   wire [31:0] 	     se_immed;
   output wire [31:0] alu_input; 
   wire [31:0] 	      alu_input_new;
   wire 	      Branch_ex;
   wire 	      MemtoReg_mem, RegWrite_mem;
   wire 	      Carryout, Overflow, Zero, Set;
   wire [31:0] 	      alu_result_mem, alu_result_ex, result_wb, Result_ex, mem_data_mem;
   wire [31:0] 	      data_wb, mem_store_data_mem;
   wire 	      lw_stall, lw_stall_id,Branch_taken,init_delay,Branch_stall_forwarding,initPC_delay4,initPC_delay6,valid;
   wire 	      kill_next_instruction_id, stall_id;
   reg 		      should_be_killed_id; 		      
   wire [31:0] 	      new_pc_if_jump_id, rs1_id_preforward, inst_id_wire;
   reg [31:0] 	      pcPlusFour_id;
   reg [1:0] 	      is_lb_ex, is_lb_mem;
   wire [1:0] 	      is_lb_id;
   wire 	      is_sb_id;
   reg 		      is_sb_ex, is_sb_mem, f_type_id, f_type_ex, f_type_mem, f_type_wb;
   reg RegWrite_ex, Extop_ex, ALUSrc_ex, MemWrite_ex, MemtoReg_ex;
   reg [4:0] ALUop_ex;
   reg [4:0] RegDst_ex, rs1_sel_ex, rs2_sel_ex;
   reg [31:0] pcPlusFour_ex, rs2_ex_preforward, rs1_ex_preforward;
   //wire [4:0] towrite_delay;
   wire [31:0]register31;
   wire jal_wr;
   // initialize or nextPC
   PC pc (.clk(clk), .CurrPC(currentPC_if), .Branch(should_branch_id), .BranchPC(new_pc_if_jump_id), .stall(stall_id), .NextPC(currentPC_if));
   defparam pc.data_file = file_name;

   always @(negedge clk) begin
      pcPlusFour_id <= currentPC_if + 4;
      cycle_count <= cycle_count + 1;
   end
   
   // instruction fetch
   //  Updates instr_if at negedge of clock. That means inst is considered after the IF/ID register, so I suffixed the output with _id.
   IF_stage cpu_if0 (.clk(clk), .PC(currentPC_if), .instr_if(inst_id_wire));
   always @(*) begin
      inst_id <= inst_id_wire; // lets us start with an initial NOP value
   end
   defparam cpu_if0.inst_name = file_name;
   
   wire [0:4] rs1_sel_id, rs2_sel_id;
   wire [4:0] RegDst_id;
   assign rs1_sel_id = inst_id[6:10];
   assign immed_id = inst_id[16:31];
   initial begin
      cycle_count = 32'h0;
      should_be_killed_id = 1'b0;
      inst_id = 31'h00_00_00_15; // need to start with NOP so there aren't any X's propogating
   end
   // Control Signal
   // Combinational logic right now
   control ctrl (.instr(inst_id), .rs1(rs1_id), .rs2_sel(rs2_sel_id), .pc_plus_four(pcPlusFour_id), .should_be_killed(should_be_killed_id), .RegWr(RegWrite_id),
		 .RegDst(RegDst_id), .ExtOp(Extop_id), .AluSrc(ALUSrc_id), .AluOp(ALUop_id), .Branch(should_branch_id), .MemWr(MemWrite_id), 
		 .MemToReg(MemtoReg_id), .new_pc_if_jump(new_pc_if_jump_id), .kill_next_instruction(kill_next_instruction_id), .stall(stall_id), 
		 .lb(is_lb_id), .jal_wr(jal_wr), .register31(register31), .sb(is_sb_id), .f_type(f_type_id));
//   dff kill (.clk(clk), .d(kill_next_instruction_id), .q(should_be_killed_id));

   // TODO: make sure rs1 contains the correct forwarded value for the branch control
                   // forward from the EX stage if the destination of the output is this register
   		   // Note we shouldn't need to worry about a lw in the execution stage 
                   //    (which would not yet have the loaded value at that point) because of the stall and killed instruction
//   assign rs1_id = (rs1_sel_id == RegDst_ex)  && (RegWrite_ex == 1) ? alu_result_ex 
//		   : // Forward from the MEM stage -- need to determine if it's the alu_result or the value from memory
//  		   (rs1_sel_id == RegDst_mem) && (RegWrite_mem == 1) 
//		     ? 
//		   (MemtoReg_mem == 1 ? mem_data_mem : alu_result_mem) 
//		       : rs1_id_preforward;
   always @ (rs1_sel_id, RegDst_id, RegDst_ex, RegDst_mem, RegWrite_mem, RegWrite_ex, MemtoReg_mem, alu_result_ex, mem_data_mem, rs1_id_preforward)
     begin
	if (rs1_sel_id == RegDst_ex && RegWrite_ex == 1) begin
	   rs1_id <= alu_result_ex;
	end
	else if(rs1_sel_id == RegDst_mem && RegWrite_mem == 1) begin
	   if (MemtoReg_mem == 1) begin
	      rs1_id <= mem_data_mem;
	   end
	   else begin
	      rs1_id <= alu_result_mem;
	   end
	end
	
	else begin
	   rs1_id <= rs1_id_preforward;
	end
     end
   
								    
   // RegisterFiles
   // Looks like it's combinational for the read, so it should be passed in a dff to ex stage?
   reg RegWrite_gpr, RegWrite_fpr;
   always @(RegWrite_mem, f_type_wb) begin
      if (RegWrite_mem == 1'h1) begin
	 if (f_type_wb == 1'h1) begin
	    RegWrite_gpr <= 0;
	    RegWrite_fpr <= 1;
	 end
	 else begin
	    RegWrite_gpr <= 1;
	    RegWrite_fpr <= 0;
	 end
      end
   end // always @ (RegWrite_mem, f_type_wb)
   

   RegisterFiles cpu_rf (.clk(clk), .writenable(RegWrite_wb), .rs1_sel(rs1_sel_id), .rs2_sel(rs2_sel_id), .writesel(RegDst_wb), .Din(data_wb), .rs1_out(rs1_id_preforward), .rs2_out(rs2_id), .r31_en(jal_wr), .register31(register31));
   RegisterFiles FP_RF (.clk(clk), .writenable(RegWrite_wb), .rs1_sel(rs1_sel_id), .rs2_sel(rs2_sel_id), .writesel(RegDst_wb), .Din(data_wb), .rs1_out(rs1_id_preforward), .rs2_out(rs2_id));

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
      rs1_ex_preforward <= rs1_id;
      rs2_ex_preforward <= rs2_id;
      // Needed to handle forwarding
      rs1_sel_ex <= rs1_sel_id;
      rs2_sel_ex <= rs2_sel_id;
      immed_ex <= immed_id;
      is_lb_ex <= is_lb_id;
      is_sb_ex <= is_sb_id;
      should_be_killed_id <= kill_next_instruction_id;
   end
  
   // sign extend the immed
   // Combinational
   // assign se_immed = Extop_ex == 1 ?
		     //	{ {16 { immed_ex[1] } }, immed_ex[0:15] } :
		     // { {16 { 1'b0        } }, immed_ex[0:15] };
   Signextend cpu_se (.Extop(Extop_ex), .Din(immed_ex), .Dout(se_immed));
   
   // Mux rs2 or immediate to get B for ALU
   // Looks like we don't worry about shamt in DLX, it's only either rs1 or the immediate as possibilites for the input
   //mux_32 cpu_mux4 (.sel(ALUSrc[1]), .src0(alu_input_new), .src1({27'b0, shamt}), .z(alu_input));
   mux_32 cpu_mux0 (.sel(ALUSrc_ex), .src0(se_immed), .src1(rs2_ex), .z(alu_input));


   // EX Stage Forwarding
   //   In theory we shouldn't have to worry about getting data from the memory because this would be killed if preceded by a LW, but I left it in
   //   If we aren't able to meet timing constraints we should look into forwarding to see if we are making our longest signal path go through 2 stages
//   assign rs1_ex = (rs1_sel_ex == RegDst_wb) && (RegWrite_wb) ? 
//		      (data_wb) : // Forward from the MEM stage -- need to determine if it's the alu_result or the value from memory
//  		   (rs1_sel_ex == RegDst_mem) && (RegWrite_mem) ? 
//		      (MemtoReg_mem ? mem_data_mem : alu_result_mem) 
//		   : rs1_ex_preforward;
//   assign rs2_ex = (rs2_sel_ex == RegDst_wb) && (RegWrite_wb) ? 
//		      (data_wb) : // Forward from the MEM stage -- need to determine if it's the alu_result or the value from memory
//  		   (rs2_sel_ex == RegDst_mem) && (RegWrite_mem) ? 
//		      (MemtoReg_mem ? mem_data_mem : alu_result_mem) 
//		     : rs2_ex_preforward;
   always @(rs1_sel_ex, RegDst_wb, RegWrite_wb, RegDst_mem, RegWrite_mem, MemtoReg_mem, mem_data_mem, alu_result_mem, rs1_ex_preforward, rs2_ex_preforward, data_wb) begin
      if (rs1_sel_ex == RegDst_mem && RegWrite_mem == 1) begin
	 if (MemtoReg_mem == 1) begin
	    rs1_ex <= mem_data_mem;
	 end
	 else begin
	    rs1_ex <= alu_result_mem;
	 end
      end
      else if (rs1_sel_ex == RegDst_wb && RegWrite_wb == 1) begin
	 rs1_ex <= data_wb;
      end
      else begin
	 rs1_ex <= rs1_ex_preforward;
      end
      
      if (rs2_sel_ex == RegDst_mem && RegWrite_mem == 1) begin
	 if (MemtoReg_mem == 1) begin
	    rs2_ex <= mem_data_mem;
	 end
	 else begin
	    rs2_ex <= alu_result_mem;
	 end
      end
      else if (rs2_sel_ex == RegDst_wb && RegWrite_wb == 1) begin
	 rs2_ex <= data_wb;
      end
      else begin
	 rs2_ex <= rs2_ex_preforward;
      end
      
   end
      
   // Execution
   // I dont think we need:
   //   valid, 
   //   initPC-delays
   // Looks like the *_ex signals are actually the outputs of the stage that are meant to be passed on. Above this I followed the opposite convention, _ex means it's used in EX stage
   //   TODO: Update this to reflect the conventions used above
   //   TODO: Update to remove the signals we don't need (valid, branch, delay, lw_stall, immed, immed_ex, etc)
   //   TODO: Confirm which each of these inputs are for. is mem_data the data to be placed in memory in the next stage, or the data from the memory from the MEM stage?
   EX_stage cpu_ex (.clk(clk), .A(rs1_ex), .B(alu_input), .Op_ex(ALUop_ex), .Carryout(Carryout), .Overflow(Overflow), .Zero(Zero), .Result_ex(alu_result_ex), .Result_mem(alu_result_mem), 
		    .Set(Set), // .immed(immed), .immed_ex(immed_ex), .opcode(opcode), .opcode_ex(opcode_mem), .Branch(should_branch_id), 
		    .MemtoReg_ex(MemtoReg_ex), .RegWrite_ex(RegWrite_ex),.MemWrite_ex(MemWrite_ex), .towrite(RegDst_ex), .Branch_ex(Branch_ex), .MemtoReg_mem(MemtoReg_mem), 
		    .RegWrite_mem(RegWrite_mem),.MemWrite_mem(MemWrite_mem), .towrite_ex(RegDst_mem), 
		    .mem_data(rs2_ex), .mem_data_ex(mem_store_data_mem), // rs2 is technically rd in i type (sw) aka the stored value
                    .rs(rs1_sel_ex),.rt(rs2_sel_ex), .ALUSrc(ALUSrc), .towrite_mem(RegDst_mem), .valid(valid),
                    .lw_stall_id(lw_stall_id),.Branch_stall_forwarding(Branch_stall_forwarding), .initPC_delay4(initPC_delay4),.initPC_delay6(initPC_delay6));//for forwarding

   always @(negedge clk) begin
      is_lb_mem <= is_lb_ex;
      is_sb_mem <= is_sb_ex;
   end
   // Since we forward the data from the memory unit in the EX stage, we don't need to forward again before the MEM Stage. 
   //  If we change the forwarding to only take initial values right out of iterstage register in order to reduce clocksycle, we will need to forward from wb stage here
								    
   //data memory
   Mem_stage cpu_mem (.clk(clk),.cs(1'b1),.oe(1'b1),.we(MemWrite_mem),.addr(alu_result_mem),.din(mem_store_data_mem),.dout(Memread), .dout_mem(mem_data_mem), .result_mem(result_wb), 
                      .MemtoReg_ex(MemtoReg_mem), .RegWrite_ex(RegWrite_mem),.MemtoReg_mem(MemtoReg_wb), .RegWrite_mem(RegWrite_wb),
                      .towrite_ex(RegDst_mem),.towrite_mem(RegDst_wb), .Branch_ex(Branch_taken),.init_delay(init_delay),
		      .Branch_stall_forwarding(Branch_stall_forwarding),.load_byte(is_lb_mem), .store_byte_in(is_sb_mem));
   defparam cpu_mem.mem_file = file_name;
   // write back
   // Literally Just a mux to determine which data gets written back
   // combinational, no dffs
   WB_stage cpu_wb (.MemtoReg(MemtoReg_wb), .Result(result_wb), .Memread(Memread), .wDin(data_wb));

   //dff dff_jal (.clk(clk), .d(jal_wr), .q(jal_wr_delay));
   //mux cpu_mux_jal (.sel(jal_wr), .src0(RegWrite_wb), .src1(1'b1), .z(RegWrite_wb_jal));
   //mux_32 cpu_mux32_jal (.sel(jal_wr), .src0(RegDst_wb), .src1(5'b11111), .z(RegDst_wb_jal));
endmodule

  
  
  
  
