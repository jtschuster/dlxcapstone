module Control_tb;
  reg [5:0] Opcode;
  wire RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, Branch, Extop;
  wire [1:0] ALUop;
  Control DUT (.Opcode(Opcode), .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .RegWrite(RegWrite),
				.MemWrite(MemWrite), .Branch(Branch), .Extop(Extop), .ALUop(ALUop));

  initial
  begin 
  Opcode = 6'b000000;
  #10
  Opcode = 6'b001000;
  #10
  Opcode = 6'b100011;
  #10
  Opcode = 6'b101011;
  #10
  Opcode = 6'b000100;
  #10
  Opcode = 6'b000101;
  #10
  Opcode = 6'b000111;
  #10
  $stop;
  end
  
 endmodule