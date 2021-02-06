module PC (clk, initPC, Branch, Zero, Overflow, Op, Immed, ALUOutput, CurrPC, NextPC, lw_stall, sel,initPC_delay9,initPC_delay4,initPC_delay6);
	input clk, initPC, Branch, Zero, Overflow,lw_stall;
	input [5:0] Op;
	input [15:0] Immed;
	input [31:0] ALUOutput, CurrPC;   
	output [31:0] NextPC;
        output sel,initPC_delay9,initPC_delay4,initPC_delay6;
wire [31:0] immedExt, immedExt_init,immedOffset, PCplus4, PCbranch, PCbranchfinal,CalcuPC, finalPC,PC_delay0,PC_delay1,PC_delay2,newfinalPC;
wire invZero, invMSB, valid_beyond, valid_bgtz, valid_zero, valid;
// unused temp variables
wire carry_0, ovflow_0, zero_0, set_0;
wire carry_1, ovflow_1, zero_1, set_1;
wire initPC_delay1, initPC_delay2,initPC_delay3,initPC_delay5,initPC_delay7,initPC_delay8,finalsel,NotinitPC,newlw_stall;


//pipeline initial 
dffr PC_initdelay1 (.clk(clk), .d(initPC), .q(initPC_delay1));
dff PC_initdelay2 (.clk(clk), .d(initPC_delay1), .q(initPC_delay2));
or_gate or_init0 (.x(initPC_delay1),.y(initPC_delay2),.z(initPC_delay3));
dff PC_initdelay4 (.clk(clk), .d(initPC_delay3), .q(initPC_delay4));
or_gate or_init1 (.x(initPC_delay3),.y(initPC_delay4),.z(initPC_delay5));
dff PC_initdelay5 (.clk(clk), .d(initPC_delay4), .q(initPC_delay6));
dff PC_initdelay6 (.clk(clk), .d(initPC_delay6), .q(initPC_delay7));
dff PC_initdelay7 (.clk(clk), .d(initPC_delay7), .q(initPC_delay8));
or_gate or_init2 (.x(initPC_delay7),.y(initPC_delay8),.z(initPC_delay9));

// signExt[imm16]*4
Signextend se_0(.Extop(1'b1), .Din(Immed), .Dout(immedExt_init));
mux_32 mux_init(.sel(initPC), .src0(immedExt_init), .src1(32'd0), .z(immedExt));

mux_32 mux_shift(.sel(1'b1), .src0(immedExt), .src1({immedExt[29:0],2'b0}), .z(immedOffset));


// PCplus4 = PC + 4
alu alu_0 (.A(CurrPC), .B(32'h4), .Op(4'b0010), .Carryout(carry_0), .Overflow(ovflow_0), .Zero(zero_0), .Result(PCplus4), .Set(set_0));

// PCbranch = PC + 4 + signExt[imm16]*4
alu alu_1 (.A(PC_delay2), .B(immedOffset), .Op(4'b0010), .Carryout(carry_1), .Overflow(ovflow_1), .Zero(zero_1), .Result(PCbranch), .Set(set_1));

//whether the output is valid
not_gate not_pc0 (.x(Zero),.z(invZero));
xnor_gate xnor_pc0 (.x(ALUOutput[31]),.y(Overflow),.z(valid_beyond));
and_gate and_bgtz (.x(valid_beyond), .y(invZero), .z(valid_bgtz));

// generate final valid signal for branch;
//whether the result is zero and whether the result is legal
mux mux_0 (.sel(Op[0]), .src0(Zero), .src1(invZero), .z(valid_zero));
mux mux_1 (.sel(Op[1]), .src0(valid_zero), .src1(valid_bgtz), .z(valid));
and_gate and_0 (.x(Branch), .y(valid), .z(sel));

// compute final PC value
mux mux_sel (.sel(initPC_delay5), .src0(sel), .src1(1'b0), .z(finalsel));
mux_32 mux_finalbranch (.sel(initPC_delay5), .src0(PCbranch), .src1(PCplus4), .z(PCbranchfinal));
mux_32 mux_2 (.sel(finalsel), .src0(PCplus4), .src1(PCbranchfinal), .z(CalcuPC));
mux_32 mux_3 (.sel(initPC), .src0(CalcuPC), .src1(32'h00400020), .z(finalPC));
//lw forwarding stall

not_gate not_pc1 (.x(initPC),.z(NotinitPC));
and_gate and_lw_stall (.x(NotinitPC), .y(lw_stall), .z(newlw_stall));
mux_32 mux_4 (.sel(newlw_stall), .src0(finalPC), .src1(PC_delay0), .z(newfinalPC));
// update PC triggered by clk

genvar i;
generate

for (i = 0; i < 32; i = i+1)
	begin
	dff dff_0 (.clk(clk), .d(newfinalPC[i]), .q(NextPC[i]));
        dff reg_PC_delay0 (.clk(clk), .d(PCplus4[i]), .q(PC_delay0[i]));
        dff reg_PC_delay1 (.clk(clk), .d(PC_delay0[i]), .q(PC_delay1[i]));
        dff reg_PC_delay2 (.clk(clk), .d(PC_delay1[i]), .q(PC_delay2[i]));
	end
endgenerate

//assign NextPC = finalPC;
endmodule
