module IF_stage (clk, PC, instr_if);
  parameter inst_name = "../data/fib.dat";
  // parameter inst_name = "../data/bills_branch.dat";
  // parameter inst_name = "../data/sort_corrected_branch.dat";
  input clk;
  input [31:0] PC;
  //output [5:0] opcode;
  //output [4:0] rs;
  //output [4:0] rt;
  //output [4:0] rd;
  //output [4:0] shamt;
  //output [5:0] funct;
  output [31:0] instr_if; 
  //output [15:0] immi;

  wire [31:0] instruction;
  ifetch instr_read (.PC(PC),.instruction(instruction));
  defparam instr_read.inst_name = inst_name;
  
  generate 
  genvar index;
  for (index=0; index < 32; index = index + 1)
	begin
        dff reg32_if (.clk(clk), .d(instruction[index]), .q(instr_if[index]));
	end
  endgenerate
  
  //assign opcode = instr_if[31:26];
  //assign rs = instr_if[25:21];
  //assign rt = instr_if[20:16];
  //assign rd = instr_if[15:11];
  //assign shamt = instr_if[10:6];
  //assign funct = instr_if[5:0];
  //assign immi = instr_if[15:0];
endmodule
