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
	       rs2_sel,
	       new_pc_if_jump,
	       kill_next_instruction,
	       stall,
	       lb,
          jal_wr,
          register31
          );
   // Should I also take in the registers so that I can determine the branch that we would take?

   input [0:31]  instr;
   input [31:0]  rs1;
   input [31:0]  pc_plus_four;
   input	 should_be_killed;
   output [31:0] new_pc_if_jump;
   output 	 RegWr;
   output [4:0]  RegDst, rs2_sel;
   output 	 ExtOp;
   output 	 AluSrc;
   output [4:0]  AluOp;
   output reg	 Branch;
   output 	 MemWr;
   output 	 MemToReg;
   output reg 	 kill_next_instruction; 	 
   output 	 stall;
   output reg [1:0] lb;
   output jal_wr;
   output [31:0] register31;
   
   initial begin // These signals are used within the component and need initial values or we end up with X's
      kill_next_instruction = 1'b0;
      Branch = 1'b0;
   end
   
   localparam [4:0] add_alu_op                     = 5'b00010;
   localparam [4:0] addu_alu_op                    = 5'b00010;
   localparam [4:0] sub_alu_op                     = 5'b00011;
   localparam [4:0] subu_alu_op                    = 5'b00011;
   localparam [4:0] and_alu_op                     = 5'b00000;
   localparam [4:0] or_alu_op                      = 5'b00001;
   localparam [4:0] xor_alu_op                     = 5'b00100;
   localparam [4:0] shift_left_alu_op              = 5'b00101;
   localparam [4:0] shift_right_logical_alu_op     = 5'b00110;
   localparam [4:0] shift_right_arithmentic_alu_op = 5'h6;
   localparam [4:0] set_eq_alu_op                  = 5'h6;
   localparam [4:0] set_neq_alu_op                 = 5'h6;
   localparam [4:0] set_gt_alu_op                  = 5'h6;
   localparam [4:0] set_lt_alu_op                  = 5'b01000;
   localparam [4:0] set_ltu_op                     = 5'b00111;
   localparam [4:0] set_geq_alu_op                 = 5'b01001;
   localparam [4:0] set_leq_alu_op                 = 5'h6;
   localparam [4:0] lhi_alu_op                     = 5'b00000;

   localparam [0:5] add_func	= 6'h20;
   localparam [0:5] addu_func	= 6'h21;
   localparam [0:5] addui_op	= 6'h09;
   localparam [0:5] addi_op	= 6'h08;
   localparam [0:5] sub_func    = 6'h18;
   localparam [0:5] subu_func   = 6'h19;   
   localparam [0:5] subui_op	= 6'h0b;
   localparam [0:5] subi_op     = 6'h0a;
   localparam [0:5] lhi_op	= 6'h0f;
   localparam [0:5] j_op	= 6'h02;
   localparam [0:5] jal_op	= 6'h03;
   localparam [0:5] jr_op	= 6'h0c;
   localparam [0:5] jalr_op     = 6'h13;
   localparam [0:5] nop_func	= 6'h15;
   localparam [0:5] lw_op	= 6'h23;
   localparam [0:5] slt_func	= 6'h28;
   localparam [0:5] beqz_op	= 6'h04;
   localparam [0:5] lb_op	= 6'h20;
   localparam [0:5] lbu_op      = 6'h24;
   localparam [0:5] sb_op	= 6'h28;
   localparam [0:5] sh_op       = 6'h29;
   localparam [0:5] sw_op	= 6'h2b;
   localparam [0:5] sgt_func	= 6'h2b;
   localparam [0:5] bnez_op	= 6'h05;
   localparam [0:5] trap_op	= 6'h11;
   localparam [0:5] xor_func    = 6'h26;
   localparam [0:5] lh_op       = 6'h21;
   localparam [0:5] lhu_op      = 6'h25;
   localparam [0:5] sgei_op     = 6'h1D;
   
   
   wire 	r_type;
   wire [0:5] 	opcode;
   wire [0:4] 	rd;
   wire [0:4] 	rs1_sel;
   wire [0:4] 	rs2_sel;
   wire [0:5] 	func;
   wire 	i_type;
   wire 	j_type;
   

   wire 	branch_instr;


   assign i_type = ~r_type && ~j_type; // Maybe should make this actually account for all i_types rather than all not r_type or j_type
   assign opcode = instr[0:5];
   assign rd = i_type 
	       ? 
	       instr[11:15] 
	       : 
	       instr[16:20];
   
   assign rs1_sel= instr[6:10];
   assign rs2_sel = instr[11:15];
   assign func = instr[26:31];
   
   
   assign r_type = (opcode == 6'h00) && (~(func == nop_func)) | 
		   (opcode == 6'h01); // MULT, MULTU, and a bunch of FP instructions
   // Only for the always jumps, doesn't include branches
   assign j_type = opcode == 6'h02 || // J
		   opcode == 6'h03 || // JAL
		   opcode == 6'h10 || // RFE
		   opcode == 6'h11;  // TRAP

   assign jal_wr = opcode == 6'h03; // JAL

   assign branch_instr = opcode == 6'h04 || // BEQZ
		         opcode == 6'h05 || // BNEZ
			 opcode == 6'h06 || // BFPT
			 opcode == 6'h07;  // BFPR
   
   
   assign RegWr  = (r_type || (i_type && ~(opcode == beqz_op ||
					   opcode == bnez_op ||
					   opcode == jr_op ||
					   opcode == jalr_op ||
					   opcode == sw_op ||
					   opcode == sh_op ||
					   opcode == sb_op))) 
		    & ~should_be_killed;
   assign RegDst = rd;
   // 1 if sign extend, 0 if 0 extend
   assign ExtOp    = opcode == subi_op ||
		     opcode == addi_op ||
		     opcode == sgei_op ||
		     opcode == lw_op ||
		     opcode == sw_op ||
		     opcode == lh_op ||
		     opcode == lhu_op ||
		     opcode == sh_op ||
		     opcode == lb_op ||
		     opcode == lbu_op ||
		     opcode == sb_op
		     ? 1'b1 : 1'b0;
   // 1 if reg, 0 if immediate
   assign AluSrc   = r_type;
   
   assign AluOp[4:0] = opcode == addi_op ||
		       opcode == 6'h00 && func == add_func ||
		       opcode == sw_op ||
		       opcode == lw_op ||
		       opcode == lb_op || 
		       opcode == lbu_op ||
		       opcode == sb_op
		       ? add_alu_op : 5'h0
		       |
		       opcode == addui_op ||
		       opcode == 6'h00 && func == addu_func
		       ? addu_alu_op : 5'h0
		       |
		       opcode == subi_op ||
		       opcode == 6'h00 && func == sub_func
		       ? sub_alu_op : 5'h0
		       |
		       opcode == 6'h00 && func == subu_func ||
		       opcode == subui_op
		       ? subu_alu_op : 5'h0
		       |
		       opcode == 6'h00 && func == xor_func 
		       ? xor_alu_op : 5'h0
		       | 
		       opcode == sgei_op 
		       ? set_geq_alu_op : 5'h0 ||
		       opcode == lhi_op
		       ? lhi_alu_op : 5'h0;
      
   assign MemWr    = (opcode == sw_op ||
		      opcode == sb_op
		      ? 1'b1 : 1'b0) &
		     ~should_be_killed;
   assign MemToReg = (opcode == lw_op || opcode == lb_op || opcode == lbu_op || opcode == lh_op || opcode == lbu_op  
		      ? 1'b1 : 1'b0) &
		     ~should_be_killed;
   assign stall = (opcode == lw_op ||
		   opcode == lh_op ||
		   opcode == lb_op ||
		   opcode == lbu_op) &
		  ~should_be_killed;
   wire 	takeBranch;
   JumpBranch jumpBranch (.instruction(instr), .pc_plus_four(pc_plus_four), .rs1(rs1), .outputPC(new_pc_if_jump), .takeBranch(takeBranch), .register31(register31));
//   assign Branch = takeBranch & ~should_be_killed;
//   assign kill_next_instruction = opcode === lw_op && ~should_be_killed || 
//				  Branch === 1'b1 && ~should_be_killed ||
//				  opcode === 6'h00 && func == nop_func && ~should_be_killed;
   always @(*) begin
      lb <= {opcode == lbu_op, opcode == lb_op};
      Branch <= takeBranch & ~should_be_killed;
      kill_next_instruction <= (opcode == lw_op || 
				opcode == lh_op || opcode == lhu_op || 
				opcode == lb_op || opcode == lbu_op) 
	                       && 
			       ~should_be_killed 
			       || 
			       Branch == 1'b1 && ~should_be_killed;
   end
   

endmodule
	
