module WB_stage (MemtoReg, Result,Memread, wDin);
  
  input MemtoReg;
  //input jal_wr;
  input [31:0] Result;
  input [31:0] Memread;
  input [31:0] register31;
  output[31:0] wDin;

  //wire [31:0] wDin_tmp;
  
  mux_32 cpu_mux1 (.sel(MemtoReg), .src0(Result), .src1(Memread), .z(wDin));
  //mux_32 cpu_mux2 (.sel(jal_wr), .src0(wDin_tmp), .src1(register31), .z(wDin));

endmodule
