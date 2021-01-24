module readReg(sel, r0,r1,r2,r3,r4,r5,r6,r7,r8,
		      r9,r10,r11,r12,r13,r14,r15,
		      r16,r17,r18,r19,r20,r21,r22,r23,
		      r24,r25,r26,r27,r28,r29,r30,r31,dataout);
  input [4:0] sel;
  input [31:0] r0,r1,r2,r3,r4,r5,r6,r7,r8,
		      r9,r10,r11,r12,r13,r14,r15,
		      r16,r17,r18,r19,r20,r21,r22,r23,
		      r24,r25,r26,r27,r28,r29,r30,r31;
  output [31:0] dataout;
  wire [31:0] index;
  wire [31:0] t0,t1,t2,t3,t4,t5,t6,t7,t8,
		      t9,t10,t11, t12,t13,t14,t15,
		      t16,t17,t18,t19,t20,t21,t22,t23,
		      t24,t25,t26,t27,t28,t29,t30;

  dec_n #(.n(5)) read_dec_0 (.src(sel), .z(index));

  mux_32 r_mux0 (.sel(index[0]), .src0(32'b0), .src1(32'b0), .z(t0));
  mux_32 r_mux1 (.sel(index[1]), .src0(t0), .src1(r1), .z(t1));
  mux_32 r_mux2 (.sel(index[2]), .src0(t1), .src1(r2), .z(t2));
  mux_32 r_mux3 (.sel(index[3]), .src0(t2), .src1(r3), .z(t3));
  mux_32 r_mux4 (.sel(index[4]), .src0(t3), .src1(r4), .z(t4));
  mux_32 r_mux5 (.sel(index[5]), .src0(t4), .src1(r5), .z(t5));
  mux_32 r_mux6 (.sel(index[6]), .src0(t5), .src1(r6), .z(t6));
  mux_32 r_mux7 (.sel(index[7]), .src0(t6), .src1(r7), .z(t7));
  mux_32 r_mux8 (.sel(index[8]), .src0(t7), .src1(r8), .z(t8));
  mux_32 r_mux9 (.sel(index[9]), .src0(t8), .src1(r9), .z(t9));
  mux_32 r_mux10 (.sel(index[10]), .src0(t9), .src1(r10), .z(t10));
  mux_32 r_mux11 (.sel(index[11]), .src0(t10), .src1(r11), .z(t11));
  mux_32 r_mux12 (.sel(index[12]), .src0(t11), .src1(r12), .z(t12));
  mux_32 r_mux13 (.sel(index[13]), .src0(t12), .src1(r13), .z(t13));
  mux_32 r_mux14 (.sel(index[14]), .src0(t13), .src1(r14), .z(t14));
  mux_32 r_mux15 (.sel(index[15]), .src0(t14), .src1(r15), .z(t15));
  mux_32 r_mux16 (.sel(index[16]), .src0(t15), .src1(r16), .z(t16));
  mux_32 r_mux17 (.sel(index[17]), .src0(t16), .src1(r17), .z(t17));
  mux_32 r_mux18 (.sel(index[18]), .src0(t17), .src1(r18), .z(t18));
  mux_32 r_mux19 (.sel(index[19]), .src0(t18), .src1(r19), .z(t19));
  mux_32 r_mux20 (.sel(index[20]), .src0(t19), .src1(r20), .z(t20));
  mux_32 r_mux21 (.sel(index[21]), .src0(t20), .src1(r21), .z(t21));
  mux_32 r_mux22 (.sel(index[22]), .src0(t21), .src1(r22), .z(t22));
  mux_32 r_mux23 (.sel(index[23]), .src0(t22), .src1(r23), .z(t23));
  mux_32 r_mux24 (.sel(index[24]), .src0(t23), .src1(r24), .z(t24));
  mux_32 r_mux25 (.sel(index[25]), .src0(t24), .src1(r25), .z(t25));
  mux_32 r_mux26 (.sel(index[26]), .src0(t25), .src1(r26), .z(t26));
  mux_32 r_mux27 (.sel(index[27]), .src0(t26), .src1(r27), .z(t27));
  mux_32 r_mux28 (.sel(index[28]), .src0(t27), .src1(r28), .z(t28));
  mux_32 r_mux29 (.sel(index[29]), .src0(t28), .src1(r29), .z(t29));
  mux_32 r_mux30 (.sel(index[30]), .src0(t29), .src1(r30), .z(t30));
  mux_32 r_mux31 (.sel(index[31]), .src0(t30), .src1(r31), .z(dataout));


endmodule