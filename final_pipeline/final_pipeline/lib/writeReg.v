module writeReg(clk, sel ,writeEnable, Din, r0,r1,r2,r3,r4,r5,r6,r7,r8,
		      r9,r10,r11,r12,r13,r14,r15,
		      r16,r17,r18,r19,r20,r21,r22,r23,
		      r24,r25,r26,r27,r28,r29,r30,r31);

  input clk;
  input writeEnable;
  input [31:0] Din;
  input [4:0] sel;
  input [31:0] r0,r1,r2,r3,r4,r5,r6,r7,r8,
		      r9,r10,r11,r12,r13,r14,r15,
		      r16,r17,r18,r19,r20,r21,r22,r23,
		      r24,r25,r26,r27,r28,r29,r30,r31;
  wire [31:0] t0,t1,t2,t3,t4,t5,t6,t7,t8,
		      t9,t10,t11,t12,t13,t14,t15,
		      t16,t17,t18,t19,t20,t21,t22,t23,
		      t24,t25,t26,t27,t28,t29,t30,t31;
  wire [31:0] index;
  wire [31:0] data_tem;
  wire [31:0] result;
  
  dec_n #(.n(5)) write_dec_0 (.src(sel), .z(index));

  and_gate wag0 (.x(index[0]), .y(writeEnable), .z(result[0]));
  and_gate wag1 (.x(index[1]), .y(writeEnable), .z(result[1]));
  and_gate wag2 (.x(index[2]), .y(writeEnable), .z(result[2]));
  and_gate wag3 (.x(index[3]), .y(writeEnable), .z(result[3]));
  and_gate wag4 (.x(index[4]), .y(writeEnable), .z(result[4]));
  and_gate wag5 (.x(index[5]), .y(writeEnable), .z(result[5]));
  and_gate wag6 (.x(index[6]), .y(writeEnable), .z(result[6]));
  and_gate wag7 (.x(index[7]), .y(writeEnable), .z(result[7])); 
  and_gate wag8 (.x(index[8]), .y(writeEnable), .z(result[8]));
  and_gate wag9 (.x(index[9]), .y(writeEnable), .z(result[9]));
  and_gate wag10 (.x(index[10]), .y(writeEnable), .z(result[10]));
  and_gate wag11 (.x(index[11]), .y(writeEnable), .z(result[11]));
  and_gate wag12 (.x(index[12]), .y(writeEnable), .z(result[12]));
  and_gate wag13 (.x(index[13]), .y(writeEnable), .z(result[13]));
  and_gate wag14 (.x(index[14]), .y(writeEnable), .z(result[14]));
  and_gate wag15 (.x(index[15]), .y(writeEnable), .z(result[15])); 
  and_gate wag16 (.x(index[16]), .y(writeEnable), .z(result[16]));
  and_gate wag17 (.x(index[17]), .y(writeEnable), .z(result[17]));
  and_gate wag18 (.x(index[18]), .y(writeEnable), .z(result[18]));
  and_gate wag19 (.x(index[19]), .y(writeEnable), .z(result[19]));
  and_gate wag20 (.x(index[20]), .y(writeEnable), .z(result[20]));
  and_gate wag21 (.x(index[21]), .y(writeEnable), .z(result[21]));
  and_gate wag22 (.x(index[22]), .y(writeEnable), .z(result[22]));
  and_gate wag23 (.x(index[23]), .y(writeEnable), .z(result[23])); 
  and_gate wag24 (.x(index[24]), .y(writeEnable), .z(result[24]));
  and_gate wag25 (.x(index[25]), .y(writeEnable), .z(result[25]));
  and_gate wag26 (.x(index[26]), .y(writeEnable), .z(result[26]));
  and_gate wag27 (.x(index[27]), .y(writeEnable), .z(result[27]));
  and_gate wag28 (.x(index[28]), .y(writeEnable), .z(result[28]));
  and_gate wag29 (.x(index[29]), .y(writeEnable), .z(result[29]));
  and_gate wag30 (.x(index[30]), .y(writeEnable), .z(result[30]));
  and_gate wag31 (.x(index[31]), .y(writeEnable), .z(result[31])); 

  mux_32 w_mux0 (.sel(result[0]), .src0(r0), .src1(Din), .z(t0));
  mux_32 w_mux1 (.sel(result[1]), .src0(r1), .src1(Din), .z(t1));
  mux_32 w_mux2 (.sel(result[2]), .src0(r2), .src1(Din), .z(t2));
  mux_32 w_mux3 (.sel(result[3]), .src0(r3), .src1(Din), .z(t3));
  mux_32 w_mux4 (.sel(result[4]), .src0(r4), .src1(Din), .z(t4));
  mux_32 w_mux5 (.sel(result[5]), .src0(r5), .src1(Din), .z(t5));
  mux_32 w_mux6 (.sel(result[6]), .src0(r6), .src1(Din), .z(t6));
  mux_32 w_mux7 (.sel(result[7]), .src0(r7), .src1(Din), .z(t7));
  mux_32 w_mux8 (.sel(result[8]), .src0(r8), .src1(Din), .z(t8));
  mux_32 w_mux9 (.sel(result[9]), .src0(r9), .src1(Din), .z(t9));
  mux_32 w_mux10 (.sel(result[10]), .src0(r10), .src1(Din), .z(t10));
  mux_32 w_mux11 (.sel(result[11]), .src0(r11), .src1(Din), .z(t11));
  mux_32 w_mux12 (.sel(result[12]), .src0(r12), .src1(Din), .z(t12));
  mux_32 w_mux13 (.sel(result[13]), .src0(r13), .src1(Din), .z(t13));
  mux_32 w_mux14 (.sel(result[14]), .src0(r14), .src1(Din), .z(t14));
  mux_32 w_mux15 (.sel(result[15]), .src0(r15), .src1(Din), .z(t15));
  mux_32 w_mux16 (.sel(result[16]), .src0(r16), .src1(Din), .z(t16));
  mux_32 w_mux17 (.sel(result[17]), .src0(r17), .src1(Din), .z(t17));
  mux_32 w_mux18 (.sel(result[18]), .src0(r18), .src1(Din), .z(t18));
  mux_32 w_mux19 (.sel(result[19]), .src0(r19), .src1(Din), .z(t19)); 
  mux_32 w_mux20 (.sel(result[20]), .src0(r20), .src1(Din), .z(t20));
  mux_32 w_mux21 (.sel(result[21]), .src0(r21), .src1(Din), .z(t21));
  mux_32 w_mux22 (.sel(result[22]), .src0(r22), .src1(Din), .z(t22));
  mux_32 w_mux23 (.sel(result[23]), .src0(r23), .src1(Din), .z(t23));
  mux_32 w_mux24 (.sel(result[24]), .src0(r24), .src1(Din), .z(t24));
  mux_32 w_mux25 (.sel(result[25]), .src0(r25), .src1(Din), .z(t25));
  mux_32 w_mux26 (.sel(result[26]), .src0(r26), .src1(Din), .z(t26));
  mux_32 w_mux27 (.sel(result[27]), .src0(r27), .src1(Din), .z(t27));
  mux_32 w_mux28 (.sel(result[28]), .src0(r28), .src1(Din), .z(t28));
  mux_32 w_mux29 (.sel(result[29]), .src0(r29), .src1(Din), .z(t29));
  mux_32 w_mux30 (.sel(result[30]), .src0(r30), .src1(Din), .z(t30));
  mux_32 w_mux31 (.sel(result[31]), .src0(r31), .src1(Din), .z(t31));
   
  write32 ww0 (.clk(clk), .din(t0), .to(r0));
  write32 ww1 (.clk(clk), .din(t1), .to(r1));
  write32 ww2 (.clk(clk), .din(t2), .to(r2));
  write32 ww3 (.clk(clk), .din(t3), .to(r3));
  write32 ww4 (.clk(clk), .din(t4), .to(r4));
  write32 ww5 (.clk(clk), .din(t5), .to(r5));
  write32 ww6 (.clk(clk), .din(t6), .to(r6));
  write32 ww7 (.clk(clk), .din(t7), .to(r7));
  write32 ww8 (.clk(clk), .din(t8), .to(r8));
  write32 ww9 (.clk(clk), .din(t9), .to(r9));
  write32 ww10 (.clk(clk), .din(t10), .to(r10));
  write32 ww11 (.clk(clk), .din(t11), .to(r11));
  write32 ww12 (.clk(clk), .din(t12), .to(r12));
  write32 ww13 (.clk(clk), .din(t13), .to(r13));
  write32 ww14 (.clk(clk), .din(t14), .to(r14));
  write32 ww15 (.clk(clk), .din(t15), .to(r15));
  write32 ww16 (.clk(clk), .din(t16), .to(r16));
  write32 ww17 (.clk(clk), .din(t17), .to(r17));
  write32 ww18 (.clk(clk), .din(t18), .to(r18));
  write32 ww19 (.clk(clk), .din(t19), .to(r19));
  write32 ww20 (.clk(clk), .din(t20), .to(r20));
  write32 ww21 (.clk(clk), .din(t21), .to(r21));
  write32 ww22 (.clk(clk), .din(t22), .to(r22));
  write32 ww23 (.clk(clk), .din(t23), .to(r23));
  write32 ww24 (.clk(clk), .din(t24), .to(r24));
  write32 ww25 (.clk(clk), .din(t25), .to(r25));
  write32 ww26 (.clk(clk), .din(t26), .to(r26));
  write32 ww27 (.clk(clk), .din(t27), .to(r27));
  write32 ww28 (.clk(clk), .din(t28), .to(r28));
  write32 ww29 (.clk(clk), .din(t29), .to(r29)); 
  write32 ww30 (.clk(clk), .din(t30), .to(r30));
  write32 ww31 (.clk(clk), .din(t31), .to(r31));
endmodule