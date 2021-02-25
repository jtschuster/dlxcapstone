module JumpBranch(instruction, pc_plus_four, rs1, outputPC, takeBranch, register31);
	input [31:0] instruction;
	input [31:0] pc_plus_four;
        input [31:0] rs1;
   
	output reg [31:0] outputPC;
        output reg 	  takeBranch;
	output reg [31:0] register31;
   
	//j, jal (sign-extend lowest 26 bits and add to PC+4):
	//jr (PC=r1)
	//beqz, bnez (I-type instructions. Sign extend 16 bt name and add to PC+4)

	reg [31:0] newPC;

	wire [5:0] opcode = instruction[31:26];
	wire [4:0] rs = instruction[25:21];
	wire [4:0] rt = instruction[20:16];
	wire [15:0] immi = instruction[15:0];

	wire [25:0] name = instruction[25:0];

	wire [31:0] signExtendedName = { { 6 { name[25] } } , name[25:0] };
	wire [31:0] signExtendedImmediate = { { 16 { immi[15] } } , immi[15:0] };

	//reg [31:0] register31;


	reg writeSelect = 1'b0;

	// Not used, but necessary to read and toss data
	wire [31:0] nullRegisterRead;


   always @(instruction, pc_plus_four, rs1, outputPC, takeBranch) begin
	if (opcode == 6'h2) begin //True for 'j' 
		//PC = PC + 4 + SignExtend(name);
		
		newPC <= pc_plus_four + signExtendedName;
	        takeBranch <= 1;
	end

	else if (opcode == 6'h3) begin //True for 'jal'
		//PC = PC + 4 + SignExtend(name);
		
		register31 <= pc_plus_four;
		newPC <= pc_plus_four + signExtendedName;
		writeSelect <= 1'b1;
	        takeBranch <= 1;
	end

   
	else if (opcode == 6'h12) begin //True for 'jr'
		newPC <= rs1;
	        takeBranch <= 1;
	end


	else if (opcode == 6'h4) begin //True for beqz'
		
		if (rs1 == 0) begin
			newPC <= pc_plus_four + signExtendedImmediate;
		        takeBranch <= 1;
		end
		else begin
		   takeBranch <= 0;
		end
	end	   
	

	else if (opcode == 6'h05) begin //True for 'bnez'

		if (rs1 != 32'h00) begin
			newPC <= pc_plus_four + signExtendedImmediate;
		        takeBranch <= 1;
		end
	   	else begin
		   takeBranch <= 0;
		end

	end
	else begin
	   newPC <= pc_plus_four;
	   takeBranch <= 0;
	   register31 <= 0;
	end

	//module RegisterFiles(clk, writenable, readsel1, readsel2, writesel, Din, Dout1, Dout2);
	//RegisterFiles reg_files(clk, 1'b1, 5'd31, 5'd0, writeSelect, register31, register_rs, null_register_read);

	outputPC <= newPC;
      end
endmodule
