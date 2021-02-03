module control_tb;
   reg [0:31] instr;
   reg [31:0] rs1;
   
   wire       RegDst, AluSrc, MemToReg, RegWr, MemWr, Branch, ExtOp;
   wire [3:0] AluOp;
   control DUT (.instr(instr), .rs1(rs1), .RegDst(RegDst), .AluSrc(AluSrc), .MemToReg(MemToReg), .RegWr(RegWr),
		.MemWr(MemWr), .Branch(Branch), .ExtOp(ExtOp), .AluOp(AluOp));
   
   
   initial
     begin 
	instr[0:5] = 6'h08; // addi 7 + rs1
	instr[6:31] = 26'h0;:q
		      
	
	rs1 = 32'h00000001;
	#10
	  instr[0:5] = 6'h00; // xor
	instr[26:31] = 6'h26;
	
	#10
	  instr[0:5] = 6'h23; // lw
	#10
	  instr[0:5] = 6'h00; // addu
	instr[27:31] = 6'h20;
	#10
	  instr[0:5] = 6'h0a; // subi
	#10
	  instr[0:5] = 6'h05; // bnez
	#10
	  instr[0:5] = 6'h2b; // sw
	#10
	  $stop;
     end
   
endmodule
