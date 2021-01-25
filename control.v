module control(
	       instr,
	       RegWr,
	       RegDst,
	       ExtOp,
	       ALUSrc,
	       ALUOp,
	       Branch,
	       MemWr,
	       MemToReg);

   input [31:0] instr;
   output 	RegWr;
   output 	RegDst;
   output 	ExtOp;
   output 	ALUSrc;
   output [4:0] ALUOp;
   output 	Branch;
   output 	MemWr;
   output 	MemToReg;
   

   localparam [4:0]   add_op = 5'h6;
   localparam [4:0]   sub_op = 5'h6;
   localparam [4:0]   and_op = 5'h6;
   localparam [4:0]   or_op  = 5'h6;
   localparam [4:0]   xor_op = 5'h6;
   localparam [4:0]   shift_left_op = 5'h6;
   localparam [4:0]   shift_right_logical_op = 5'h6;
   localparam [4:0]   shift_right_arithmentic_op = 5'h6;
   localparam [4:0]   set_eq_op = 5'h6;
   localparam [4:0]   set_neq_op = 5'h6;
   localparam [4:0]   set_gt_op = 5'h6;
   localparam [4:0]   set_lt_op = 5'h6;
   localparam [4:0]   set_geq_op = 5'h6;
   localparam [4:0]   set_leq_op = 5'h6;
   

   
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
   
   
   assign r_type = !(| opcode) && (~ func == nop_func) | 
		   (opcode == 6'h01); // MULT, MULTU, and a bunch of FP instructions
   // Only for the always jumps, doesn't include branches
   assign j_type[5:0] = opcode == 6'h02 | // J
			opcode == 6'h03 | // JAL
			opcode == 6'h10 | // RFE
			opcode == 6'h11;  // TRAP
   assign branch_instr[5:0] = opcode == 6'h04 | // BEQZ
			      opcode == 6'h05 | // BNEZ
			      opcode == 6'h06 | // BFPT
			      opcode == 6'h07;  // BFPR
   
   
   assign RegWr  = r_type;
   assign RegDst = rd;
   // 1 if sign extend, 0 if 0 extend
   assign ExtOp    = 'b0;
   // 1 if reg, 0 if immediate
   assign ALUSrc   = r_type;
   
   assign ALUOp    = ;
   
   assign Branch   = j_type |
		     i_type && branch_instr;
   assign MemWr    = 'b0;
   assign MemToReg = 'b0;


    

endmodule
	
