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

   wire [5:0] 	opcode;
   wire [5:0] 	rd;
   wire [5:0] 	rs1;
   wire [5:0] 	rs2;
   wire [5:0] 	func;
   wire [15:0] 	immediate;

   wire 	r_type;
   wire [5:0] 	nop_func;


   assign nop_func = 6'h15;



   assign opcode = instr[5:0];
   assign rd = instr[10:6];
   assign rs1 = instr[15:11];
   assign rs2 = instr[20:16];
   assign func = instr[31:27];

   
   assign r_type = (| opcode) && (~ func == nop_func);
   
   
   assign RegWr  = instr[3] | instr[24];
   assign RegDst = | instr[7:3];
   assign ExtOp  = instr[13];
   assign ALUSrc = instr[25];
   assign ALUOp  = instr[15:11];
   assign Branch = instr[21];
   assign MemWr  = instr[17];
   assign MemToReg = instr[19];
   

endmodule
	
