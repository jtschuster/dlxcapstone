//`timescale 1ns/10ps
module CPU_tb;
	reg clk;
	wire [31:0] regPC;
	wire [31:0] inst;
	wire [31:0] Dout1, Dout2;
    wire [31:0] Memread;
	wire [4:0] rt, rs, rd;
    wire [5:0] opcode;
    //FOR CONTROL
	wire RegDst, Branch;
	wire [1:0] ALUSrc;
	//for alu
	wire [31:0] Result;
    wire [31:0] alu_input;
    wire[31:0] pc_lim;
    CPU scp ( .clk(clk), .currentPC_if(regPC), .inst_id(inst), .rs1_id(Dout1), .rs2_id(Dout2), .Memread(Memread), .ALUSrc(ALUSrc), .should_branch_id(Branch),.alu_input(alu_input));
    defparam scp.file_name = "data/unsignedsum.dat";
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
        #10
		clk = 1'b0;
		#10
		for(i = 0; (i < 5000) && (regPC < pc_lim); i=i+1) begin
		clk = 1'b1;
		#10
		clk = 1'b0;
		#10;
		end
		
	
	
	end



endmodule
