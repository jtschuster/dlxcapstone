module ifetch_tb;
  reg [31:0] PC;
  wire [5:0] opcode;
  wire [4:0] rs;
  wire [4:0] rt;
  wire [4:0] rd;
  wire [4:0] shamt;
  wire [5:0] funct;
  wire [31:0] instruction;
  wire [15:0] immi;
  
  ifetch if1 (.PC(PC), .opcode(opcode), .rs(rs), .rt(rt), .rd(rd), .shamt(shamt), .funct(funct), .instruction(instruction), .immi(immi));
  defparam if1.inst_name = "eecs361/data/unsigned_sum.dat";
  
  initial
  begin
  PC = 32'h00400020;
  #10
  PC = 32'h00400024;
  #10
  PC = 32'h00400028;
  #10
  PC = 32'h00400094;
  #10  
  PC = 32'h00400104;
  #10  
  $stop;
  end 
endmodule