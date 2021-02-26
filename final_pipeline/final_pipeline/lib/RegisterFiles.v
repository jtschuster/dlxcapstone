module RegisterFiles(clk, writenable, rs1_sel, rs2_sel, writesel, Din, rs1_out, rs2_out, r31_en, register31);
   input clk;
   input writenable;
   input [4:0] rs1_sel, rs2_sel, writesel;
   input [31:0] Din;
   input r31_en;
   input [31:0] register31;
   output reg [31:0] rs1_out, rs2_out;
   reg [31:0] r [31:0];
   integer    i;
   initial begin
      for (i=0; i<32; i = i+1) begin
	 r[i] = 32'h0;
      end
   end
   always @ * begin
      if (rs1_sel == 0) begin
	 rs1_out <= 32'h0;
      end
      if (rs2_sel == 0) begin
	 rs2_out <= 32'h0;
      end
      for (i=1; i<32; i = i+1) begin
	 if (rs1_sel == i) begin
	    rs1_out <= r[i];
	 end
	 if (rs2_sel == i) begin
	    rs2_out <= r[i];
	 end
      end
   end // always @ *
   always @ (posedge clk) begin
      if (writenable == 1) begin
	 $display("clocked");
	 for (i=1; i<32; i= i+1) begin
	    $display("writsel, i", writesel, i, writesel==i);
	    if (writesel == i) begin
	       r[i] <= Din;
	    end
	 end
      end
   end
   
   always @ (posedge clk) begin
      if (r31_en == 1)begin
        r[31] <= register31;
      end
   end
   
//   always begin
//      case (rs1_sel)
//	5'd0: begin 
//	  rs1_out <= 32'h0000;
//	end
//	5'd1: begin 
//	  rs1_out <= r1;
//	end
//	5'd2: begin 
//	  rs1_out <= r1;
//	end
//	5'd3: begin 
//	  rs1_out <= r1;
//	end
//	5'd4: begin 
//	  rs1_out <= r1;
//	end
//	5'd5: begin 
//	  rs1_out <= r1;
//	end
//	5'd6: begin 
//	  rs1_out <= r1;
//	end
//	5'd7: begin 
//	  rs1_out <= r1;
//	end
//	5'd8: begin 
//	  rs1_out <= r1;
//	end
//	5'd9: begin 
//	  rs1_out <= r1;
//	end
//	5'd10: begin 
//	  rs1_out <= r1;
//	end
//	5'd11: begin 
//	  rs1_out <= r1;
//	end
//	5'd12: begin 
//	  rs1_out <= r1;
//	end
//	5'd13: begin 
//	  rs1_out <= r1;
//	end
//	5'd14: begin 
//	  rs1_out <= r1;
//	end
//	5'd15: begin 
//	  rs1_out <= r1;
//	end
//	5'd16: begin 
//	  rs1_out <= r1;
//	end
//	5'd17: begin 
//	  rs1_out <= r1;
//	end
//	5'd18: begin 
//	  rs1_out <= r1;
//	end
//	5'd19: begin 
//	  rs1_out <= r1;
//	end
//	5'd20: begin 
//	  rs1_out <= r1;
//	end
//	5'd21: begin 
//	  rs1_out <= r1;
//	end
//	5'd22: begin 
//	  rs1_out <= r1;
//	end
//	5'd23: begin 
//	  rs1_out <= r1;
//	end
//	5'd24: begin 
//	  rs1_out <= r1;
//	end
//	5'd25: begin 
//	  rs1_out <= r1;
//	end
//	5'd26: begin 
//	  rs1_out <= r1;
//	end
//	5'd27: begin 
//	  rs1_out <= r1;
//	end
//	5'd28: begin 
//	  rs1_out <= r1;
//	end
//	5'd29: begin 
//	  rs1_out <= r1;
//	end
//	5'd30: begin 
//	  rs1_out <= r1;
//	end
//	5'd31: begin 
//	  rs1_out <= r1;
//	end
	
	
//   wire [31:0] 	r0,r1,r2,r3,r4,r5,r6,r7,r8,
//		r9,r10,r11,r12,r13,r14,r15,
//		r16,r17,r18,r19,r20,r21,r22,r23,
//		r24,r25,r26,r27,r28,r29,r30,r31;
//	writeReg wR0 (.clk(clk), .sel(writesel) ,.writeEnable(writenable), .Din(Din), 
//	.r0(r0),.r1(r1),.r2(r2),.r3(r3),.r4(r4),.r5(r5),.r6(r6),.r7(r7),.r8(r8),
//	.r9(r9),.r10(r10),.r11(r11),.r12(r12),.r13(r13),.r14(r14),.r15(r15),
//	.r16(r16),.r17(r17),.r18(r18),.r19(r19),.r20(r20),.r21(r21),.r22(r22),.r23(r23),
//	.r24(r24),.r25(r25),.r26(r26),.r27(r27),.r28(r28),.r29(r29),.r30(r30),.r31(r31));
//	 
//	readReg rR0 (.sel(rs1_sel), .r0(r0),.r1(r1),.r2(r2),.r3(r3),.r4(r4),.r5(r5),.r6(r6),.r7(r7),.r8(r8),
//	.r9(r9),.r10(r10),.r11(r11),.r12(r12),.r13(r13),.r14(r14),.r15(r15),
//	.r16(r16),.r17(r17),.r18(r18),.r19(r19),.r20(r20),.r21(r21),.r22(r22),.r23(r23),
//	.r24(r24),.r25(r25),.r26(r26),.r27(r27),.r28(r28),.r29(r29),.r30(r30),.r31(r31),.dataout(rs1_out));
//	 
//	readReg rR1 (.sel(rs2_sel), .r0(r0),.r1(r1),.r2(r2),.r3(r3),.r4(r4),.r5(r5),.r6(r6),.r7(r7),.r8(r8),
//	.r9(r9),.r10(r10),.r11(r11),.r12(r12),.r13(r13),.r14(r14),.r15(r15),
//	.r16(r16),.r17(r17),.r18(r18),.r19(r19),.r20(r20),.r21(r21),.r22(r22),.r23(r23),
//	.r24(r24),.r25(r25),.r26(r26),.r27(r27),.r28(r28),.r29(r29),.r30(r30),.r31(r31),.dataout(rs2_out));
//   initial begin
//      r0 = 0;
//      r1 = 0;
//      r2 = 0;
//      r3 = 0;
//      r4 = 0;
//   end
endmodule
