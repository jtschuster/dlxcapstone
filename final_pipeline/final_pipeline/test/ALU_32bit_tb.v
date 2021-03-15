module ALU_32bit_tb;

reg [31:0] opa_tb;
reg [31:0] opb_tb;
reg [4:0] ctrl_tb;
wire [31:0] z_alu_tb;
wire cout_tb;
wire overflow_tb;
wire zero_tb;
wire set_tb;

alu alu_inst(
	.A(opa_tb),
	.B(opb_tb),
	.Op(ctrl_tb),
	.Result(z_alu_tb),
	.Carryout(cout_tb),
	.Overflow(overflow_tb),
	.Zero(zero_tb),
	.Set(set_tb)
	);

initial begin

	//opa_tb = -32'd15; opb_tb = 32'd205; ctrl_tb=5'b00011; //sub 0x03
        opa_tb = 32'h5; opb_tb = 32'h4; ctrl_tb=5'b00011;
	#10
	opa_tb = 32'd1023; opb_tb = 32'd2; ctrl_tb=5'b00101; //sll 0x06
	#10
        opa_tb = 32'd1023; opb_tb = 32'd2; ctrl_tb=5'b00110; //srl 0x07
	#10
        opa_tb = -32'd15; opb_tb = -32'd7; ctrl_tb=5'b01000; //slt 0x0C
	#10
        opa_tb = 32'd1024; opb_tb = 32'd2133; ctrl_tb=5'b00111; //sltu 0x1C
	#10
        opa_tb = 32'd3024; opb_tb = 32'd2133; ctrl_tb=5'b01001; //sgeq 0x1C
	#10
        opa_tb = -32'd45; opb_tb = -32'd20; ctrl_tb=5'b00010; //adder neg + neg 0x00
	#10
        opa_tb = 32'd100; opb_tb = 32'd2147483645; ctrl_tb=5'b00010; //adder overflow 0x03
	#10
        opa_tb = -32'd1; opb_tb = 32'd1; ctrl_tb=5'b00010; //adder zero detection 0x03
	#10
	opa_tb = -32'd5; opb_tb = -32'd70; ctrl_tb=5'b00011; // sub neg - neg 0x0A
	#10
	opa_tb = 32'd1; opb_tb = 32'd4; ctrl_tb=5'b00001; // or 0x01
	#10
        opa_tb = 32'd7; opb_tb = 32'd5; ctrl_tb=5'b00000; // and 0x02
	#10
        opa_tb = 32'd13; opb_tb = 32'd7; ctrl_tb=5'b00100; // xor 0x03
	#10
        opa_tb = 32'h41700000; opb_tb = 32'h43700000; ctrl_tb=5'b01111; // Addf 15, 240 
	#10
        opa_tb = 32'd15; opb_tb = 32'h00000000; ctrl_tb=5'b11110; // CVTITF 1
	#10
        opa_tb = 32'd15; opb_tb = 32'h00000000; ctrl_tb=5'b11110; // CVTITF 1
        #10
        opa_tb = 32'h4e7fffff; ctrl_tb=5'b11111; 
	#10
        opa_tb = 32'h44800000; ctrl_tb=5'b11111; 
#10
opa_tb = 32'h0;
end
endmodule
