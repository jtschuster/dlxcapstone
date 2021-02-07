module control(
	       instr,
	       rs1,
	       pc_plus_four,
	       should_be_killed, // for instructions that follow a lw that should be stalled
	       RegWr,
	       RegDst,
	       ExtOp,
	       AluSrc,
	       AluOp,
	       Branch,
	       MemWr,
	       MemToReg,
	       new_pc_if_jump,
	       kill_next_instruction,
	       stall);
   // Should I also take in the registers so that I can determine the branch that we would take?

   input [0:31]  instr;
   input [31:0]  rs1;
   input [31:0]  pc_plus_four;
   input 	 should_be_killed;
   output [31:0] new_pc_if_jump;
   output 	 RegWr;
   output [4:0]  RegDst;
   output 	 ExtOp;
   output 	 AluSrc;
   output [3:0]  AluOp;
   output 	 Branch;
   output 	 MemWr;
   output 	 MemToReg;
   output 	 kill_next_instruction; 	 
   output 	 stall;

   localparam [3:0] add_alu_op                     = 4'b0011;
   localparam [3:0] addu_alu_op                    = 4'b0010;
   localparam [3:0] sub_alu_op                     = 4'b0100;
   localparam [3:0] subu_alu_op                    = 4'b0111;
   localparam [3:0] and_alu_op                     = 4'b0000;
   localparam [3:0] or_alu_op                      = 4'b0001;
   localparam [3:0] xor_alu_op                     = 4'b0100;
   localparam [3:0] shift_left_alu_op              = 4'b1001;
   localparam [3:0] shift_right_logical_alu_op     = 4'b1110;
   localparam [3:0] shift_right_arithmentic_alu_op = 4'h6;
   localparam [3:0] set_eq_alu_op                  = 4'h6;
   localparam [3:0] set_neq_alu_op                 = 4'h6;
   localparam [3:0] set_gt_alu_op                  = 4'h6;
   localparam [3:0] set_lt_alu_op                  = 4'b0101;
   localparam [3:0] set_geq_alu_op                 = 4'h6;
   localparam [3:0] set_leq_alu_op                 = 4'h6;

   localparam [0:5] add_func	= 6'h20;
   localparam [0:5] addu_func	= 6'h21;
   localparam [0:5] addui_op	= 6'h09;
   localparam [0:5] addi_op	= 6'h08;
   localparam [0:5] sub_func    = 6'h18;
   localparam [0:5] subu_func   = 6'h19;   
   localparam [0:5] subui_op	= 6'h0b;
   localparam [0:5] subi_op     = 6'h0a;
   localparam [0:5] sw_op	= 6'h2b;
   localparam [0:5] jal_op	= 6'h03;
   localparam [0:5] lhi_op	= 6'h0f;
   localparam [0:5] j_op	= 6'h02;
   localparam [0:5] nop_func	= 6'h15;
   localparam [0:5] lw_op	= 6'h23;
   localparam [0:5] slt_func	= 6'h28;
   localparam [0:5] beqz_op	= 6'h04;
   localparam [0:5] jr_op	= 6'h0c;
   localparam [0:5] lb_op	= 6'h20;
   localparam [0:5] sb_op	= 6'h28;
   localparam [0:5] lbu_op	= 6'h24;
   localparam [0:5] sgt_func	= 6'h2b;
   localparam [0:5] bnez_op	= 6'h05;
   localparam [0:5] trap_op	= 6'h11;
   localparam [0:5] xor_func    = 6'h26;
   localparam [0:5] lh_op       = 6'h21;
   
   
   
   wire 	r_type;
   wire [0:5] 	opcode;
   wire [0:5] 	rd;
   wire [0:5] 	rs1;
   wire [0:5] 	rs2;
   wire [0:5] 	func;
   wire [15:0] 	immediate;
   
   wire 	i_type;
   wire [15:0]	imm; 	

   wire 	j_type;
   wire [26:0] 	offset;

   wire 	branch_instr;



   assign opcode = instr[0:5];
   assign rd = instr[6:10];
   assign rs1 = instr[11:15];
   assign rs2 = instr[16:20];
   assign func = instr[27:31];
   
   
   assign r_type = !(opcode == 6'h00) && (~(func == nop_func)) | 
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
   
   
   assign RegWr  = r_type & ~should_be_killed;
   assign RegDst = rd;
   // 1 if sign extend, 0 if 0 extend
   assign ExtOp    = opcode == subi_op ||
		     opcode == addi_op
		     ? 1'b1 : 1'b0;
   // 1 if reg, 0 if immediate
   assign AluSrc   = r_type;
   
   assign AluOp[3:0] = opcode == addi_op ||
		       opcode == 6'h00 && func == add_func ||
		       opcode == sw_op ||
		       opcode == lw_op ||
		       opcode == lb_op ||
		       opcode == sb_op
		       ? add_alu_op : 4'h0
		       |
		       opcode == addui_op ||
		       opcode == 6'h00 && func == addu_func
		       ? addu_alu_op : 4'h0
		       |
		       opcode == subi_op ||
		       opcode == 6'h00 && func == sub_func
		       ? sub_alu_op : 4'h0
		       |
		       opcode == 6'h00 && func == subu_func ||
		       opcode == subui_op
		       ? subu_alu_op : 4'h0
		       |
		       opcode == 6'h0;
   
   assign Branch   = j_type |
		     opcode == beqz_op && rs1 == 32'h00000000 ||
		     opcode == bnez_op && rs1 != 32'h00000000 ;
   
   assign MemWr    = (opcode == sw_op ||
		      opcode == sb_op
		      ? 1'b1 : 1'b0) &
		     ~should_be_killed;
   assign MemToReg = (opcode == lw_op // also lh and lb 
		      ? 1'b1 : 1'b0) &
		     ~should_be_killed;
   assign stall = (opcode == lw_op ||
		   opcode == lh_op ||
		   opcode == lb_op);
   wire 	takeBranch;
   JumpBranch jumpBranch (.instruction(instr), .inputPC(pc_plus_four), .rs1(rs1), .outputPC(new_pc_if_jump), .takeBranch(takeBranch));
   assign Branch = takeBranch & ~should_be_killed;
   assign kill_next_instr = opcode == lw_op;
   

endmodule
	
