module control(
	       instr,
	       rs1,
	       RegWr,
	       RegDst,
	       ExtOp,
	       ALUSrc,
	       ALUOp,
	       Branch,
	       MemWr,
	       MemToReg);
   // Should I also take in the registers so that I can determine the branch that we would take?

   input [31:0] instr;
   input [31:0] rs1;
   output 	RegWr;
   output 	RegDst;
   output 	ExtOp;
   output 	ALUSrc;
   output [4:0] ALUOp;
   output 	Branch;
   output 	MemWr;
   output 	MemToReg;
   

   localparam [4:0]   add_alu_opr                    = 5'h6;
   localparam [4:0]   sub_alu_op                     = 5'h6;
   localparam [4:0]   and_alu_op                     = 5'h6;
   localparam [4:0]   or_alu_op                      = 5'h6;
   localparam [4:0]   xor_alu_op                     = 5'h6;
   localparam [4:0]   shift_left_alu_op              = 5'h6;
   localparam [4:0]   shift_right_logical_alu_op     = 5'h6;
   localparam [4:0]   shift_right_arithmentic_alu_op = 5'h6;
   localparam [4:0]   set_eq_alu_op = 5'h6;
   localparam [4:0]   set_neq_alu_op = 5'h6;
   localparam [4:0]   set_gt_alu_op = 5'h6;
   localparam [4:0]   set_lt_alu_op = 5'h6;
   localparam [4:0]   set_geq_alu_op = 5'h6;
   localparam [4:0]   set_leq_alu_op = 5'h6;

   localparam [5:0] add_func = 6'h20;
   localparam [5:0] addu_func = 6'h21;
   localparam [5:0] addui_op = 6'h09;
   localparam [5:0] addi_op = 6'h08;
   localparam [5:0] subui = 6'h0b;
   localparam [5:0] sw_op = 6'h2b;
   localparam [5:0] jal_op = 6'h03;
   localparam [5:0] lhi_op = 6'h0f;
   localparam [5:0] j_op = 6'h02;
   localparam [5:0] nop_func = 6'h15;
   localparam [5:0] lw_op = 6'h23;
   localparam [5:0] slt_func = 6'h28;
   localparam [5:0] beqz_op = 6'h04;
   localparam [5:0] jr_op = 6'h1 
   localparam [5:0] lb_op = 6'h20;
   localparam [5:0] sb_op = 6'h28;
   localparam [5:0] lbu_op = 6'h24;
   localparam [5:0] sgt_func = 6'h2b;
   localparam [5:0] bnez_op = 6'h05;
   localparam [5:0] trap_op = 6'h11;
   
   
   wire 	r_type;
   wire [5:0] 	opcode;
   wire [5:0] 	rd;
   wire [5:0] 	rs1;
   wire [5:0] 	rs2;
   wire [5:0] 	func;
   wire [15:0] 	immediate;
   
   wire 	i_type;
   wire [15:0]	imm; 	

   wire 	j_type;
   wire [26:0] 	offset;
   wire [5:0] 	nop_func;

   wire 	branch_instr;
   
   
   assign nop_func = 6'h15;



   assign opcode = instr[5:0];
   assign rd = instr[10:6];
   assign rs1 = instr[15:11];
   assign rs2 = instr[20:16];
   assign func = instr[31:27];
   
   
   assign r_type = !(opcode == 6'0x00) && (~(func == nop_func)) | 
		   (opcode == 6'h01); // MULT, MULTU, and a bunch of FP instructions
   // Only for the always jumps, doesn't include branches
   assign j_type = opcode == 6'h02 || // J
		   opcode == 6'h03 || // JAL
		   opcode == 6'h10 || // RFE
		   opcode == 6'h11;  // TRAP
   assign branch_instr = opcode == 6'h04 || // BEQZ
		         opcode == 6'h05 || // BNEZ
			 opcode == 6'h06 || // BFPT
			 opcode == 6'h07;  // BFPR
   
   
   assign RegWr  = r_type;
   assign RegDst = rd;
   // 1 if sign extend, 0 if 0 extend
   assign ExtOp    = opcode == subi_op
		     ? 1'b1 : 1'b0;
   // 1 if reg, 0 if immediate
   assign ALUSrc   = r_type;
   
   assign ALUOp[4:0] = opcode == addi_op ||
		       opcode == addui_op ||
		       opcode == 6'h00 && func == add_func ||
		       opcode == sw_op ||
		       opcode == lw_op ||
		       opcode == lb_op ||
		       opcode == sb_op
		       ? add_alu_op : 5'h00
		       |
		       opcode == subui
		       ? sub_alu_op : 5'h00
		       ;
   
   assign Branch   = j_type |
		     opcode == beqz_op && rs1 == 32'h00000000 ||
		     opcode == bnez_op && rs1 != 32'h00000000 ||
		     opcode == ; 
   assign MemWr    = opcode == sw_op ||
		     opcode == sb_op ||
		     ? 1'b1 : 1'b0;
   assign MemToReg = 
		     ? 1'b1 : 1'b0;


    

endmodule
	
