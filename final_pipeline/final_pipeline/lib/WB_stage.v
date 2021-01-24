module WB_stage (MemtoReg, Result,Memread, wDin);
  
  input MemtoReg;
  input [31:0] Result;
  input [31:0] Memread;
  output[31:0] wDin;
  
  mux_32 cpu_mux1 (.sel(MemtoReg), .src0(Result), .src1(Memread), .z(wDin));
endmodule
