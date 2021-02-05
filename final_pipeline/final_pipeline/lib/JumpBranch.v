module JumpBranch(clk, instruction, inputPC, rs1, outputPC, takeBranch);

	input clk;
	input [31:0] instruction;
	input [31:0] inputPC;
        input [31:0] rs1, register31;
   
	output [31:0] outputPC;
        output 	      takeBranch;
   
	//j, jal (sign-extend lowest 26 bits and add to PC+4):
	//jr (PC=r1)
	//beqz, bnez (I-type instructions. Sign extend 16 bt name and add to PC+4)

	wire [31:0] newPC;


	wire [5:0] opcode = instruction[31:26];
	wire [4:0] rs = instruction[25:21];
	wire [4:0] rt = instruction[20:16];
	wire [15:0] immi = instruction[15:0];

	wire [25:0] name = instruction[25:0];

        // Does this notation work right?
	wire [31:0] signExtendedName = name <<< 6;
	wire [31:0] signExtendedImmediate = immi <<< 16;

	wire [31:0] register31;


	wire writeSelect = 1'b0;

	// Not used, but necessary to read and toss data
	wire [31:0] nullRegisterRead;



	if (opcode == 6'h2) begin //True for 'j' 
		//PC = PC + 4 + SignExtend(name);
		
		newPC = inputPC + 4 + signExtendedName;
	        takeBranch = 1;
	end


	if (opcode == 6'h3) begin //True for 'jal'
		//PC = PC + 4 + SignExtend(name);
		
		register31 = inputPC + 4;
		newPC = inputPC + 4 + signExtendedName;
		writeSelect = 1'b1;
	        takeBranch = 1;
	end


	if (opcode == 6'h12) begin //True for 'jr'
		newPC = rs1;
	        takeBranch = 1;
	end


	if (opcode == 6'h4) begin //True for 'beqz'
		
		if (register_rs == 0) begin
			newPC = inputPC + 4 + signExtendedImmediate;
		        takeBranch = 1;
		end
	
	end


	if (opcode == 6'h5) begin //True for 'bnez'

		if (register_rs != 0) begin
			newPC = inputPC + 4 + signExtendedImmediate;
		        takeBranch = 1;
		end

	end


	//module RegisterFiles(clk, writenable, readsel1, readsel2, writesel, Din, Dout1, Dout2);
	//RegisterFiles reg_files(clk, 1'b1, 5'd31, 5'd0, writeSelect, register31, register_rs, null_register_read);

	outputPC = newPC;

endmodule
