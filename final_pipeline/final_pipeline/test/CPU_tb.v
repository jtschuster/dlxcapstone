//`timescale 1ns/10ps
module CPU_tb;
	reg clk;
	reg initPC;
	wire [31:0] nextPC, regPC;
	wire [31:0] inst;
	wire [31:0] wDin, Dout1, Dout2;
    wire [31:0] Memread;
	wire [4:0] rt, rs, rd, shamt;
    wire [5:0] opcode, funct;
    wire [15:0] immed;
    //FOR CONTROL
	wire RegDst, MemtoReg, RegWrite, MemWrite, Branch, Extop;
	wire [1:0] ALUSrc;
    wire [1:0] ALUop;
	//for alu
	wire [31:0] Result;
    wire [31:0] alu_input;
    wire [3:0] alu_control;
    wire[31:0] pc_lim;
    CPU scp ( .clk(clk), .initPC(initPC),.nextPC(nextPC), .currentPC_if(regPC), .inst_id(inst), .wDin(wDin), .rs1_id(Dout1), .rs2_id(Dout2), .Memread(Memread), .shamt(shamt), .funct(funct), .immed(immed), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .RegWrite(RegWrite), .MemWrite(MemWrite), .should_branch_id(Branch), .Extop(Extop),.ALUop(ALUop), .Result(Result),.alu_input(alu_input),.alu_control(alu_control));
    defparam scp.file_name = "data/fib.dat";
    assign pc_lim = 32'h00400054;
    //defparam scp.file_name = "data/bills_branch.dat";
    //assign pc_lim = 32'h00400060;
    //defparam scp.file_name = "data/sort_corrected_branch.dat";
    //assign pc_lim = 32'h0040006c;
    //bills_branch;sort_corrected_branch;unsigned_sum;
    integer i;	
	initial
      begin
	    clk = 1'b1;                                                                                                                                                                                                                                                                                                                                                                                                                                   
        initPC = 1'b1;
        #10
		clk = 1'b0;
		initPC = 1'b0;
		#10
		for(i = 0; (i < 5000) && (regPC < pc_lim); i=i+1) begin
		clk = 1'b1;
		#10
		clk = 1'b0;
		#10;
		end
		
	
	
	end



endmodule
