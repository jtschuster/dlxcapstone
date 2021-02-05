module RegisterFiles(clk, writenable, rs1_sel, rs2_sel, writesel, Din, rs1_out, rs2_out);
   input clk;
   input writenable;
   input [4:0] rs1_sel, rs2_sel, writesel;
   input [31:0] Din;
   output [31:0] rs1_out, rs2_out;
   wire [31:0] 	r0,r1,r2,r3,r4,r5,r6,r7,r8,
		r9,r10,r11,r12,r13,r14,r15,
		r16,r17,r18,r19,r20,r21,r22,r23,
		r24,r25,r26,r27,r28,r29,r30,r31;
	writeReg wR0 (.clk(clk), .sel(writesel) ,.writeEnable(writenable), .Din(Din), 
	.r0(r0),.r1(r1),.r2(r2),.r3(r3),.r4(r4),.r5(r5),.r6(r6),.r7(r7),.r8(r8),
	.r9(r9),.r10(r10),.r11(r11),.r12(r12),.r13(r13),.r14(r14),.r15(r15),
	.r16(r16),.r17(r17),.r18(r18),.r19(r19),.r20(r20),.r21(r21),.r22(r22),.r23(r23),
	.r24(r24),.r25(r25),.r26(r26),.r27(r27),.r28(r28),.r29(r29),.r30(r30),.r31(r31));
	 
	readReg rR0 (.sel(rs1_sel), .r0(r0),.r1(r1),.r2(r2),.r3(r3),.r4(r4),.r5(r5),.r6(r6),.r7(r7),.r8(r8),
	.r9(r9),.r10(r10),.r11(r11),.r12(r12),.r13(r13),.r14(r14),.r15(r15),
	.r16(r16),.r17(r17),.r18(r18),.r19(r19),.r20(r20),.r21(r21),.r22(r22),.r23(r23),
	.r24(r24),.r25(r25),.r26(r26),.r27(r27),.r28(r28),.r29(r29),.r30(r30),.r31(r31),.dataout(Dout1));
	 
	readReg rR1 (.sel(rs2_sel), .r0(r0),.r1(r1),.r2(r2),.r3(r3),.r4(r4),.r5(r5),.r6(r6),.r7(r7),.r8(r8),
	.r9(r9),.r10(r10),.r11(r11),.r12(r12),.r13(r13),.r14(r14),.r15(r15),
	.r16(r16),.r17(r17),.r18(r18),.r19(r19),.r20(r20),.r21(r21),.r22(r22),.r23(r23),
	.r24(r24),.r25(r25),.r26(r26),.r27(r27),.r28(r28),.r29(r29),.r30(r30),.r31(r31),.dataout(Dout2));
endmodule
