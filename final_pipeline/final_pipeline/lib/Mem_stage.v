module Mem_stage (clk,cs,oe,we,addr,din, dout, dout_mem, result_mem, MemtoReg_ex, RegWrite_ex,towrite_ex,MemtoReg_mem, RegWrite_mem,towrite_mem,Branch_ex,init_delay,Branch_stall_forwarding);
  
  parameter mem_file = "../data/fib.dat";
  //parameter mem_file = "../data/bills_branch.dat";
  //parameter mem_file = "../data/sort_corrected_branch.dat";
  input clk;
  input cs;
  input oe;
  input we;
  input MemtoReg_ex, RegWrite_ex,Branch_ex,init_delay;
  input [4:0] towrite_ex;
  input [31:0] addr;
  input [31:0] din;
  //input load_byte;
  output [31:0] dout, dout_mem;
  output [31:0] result_mem;
  output MemtoReg_mem, RegWrite_mem, Branch_stall_forwarding;
  output [4:0] towrite_mem;
  wire [31:0] dout_tmp;
  wire Branch_mem, Branch_mem_delay0, Branch_mem_delay1, stall,Branch_ex_new, invinit_delay,stall_new;
  wire we_new,newRegWrite_ex,finalnewRegWrite_ex;
  syncram cpu_scm (.clk(clk),.cs(cs),.oe(oe),.we(we_new),.addr(addr),.din(din),.dout(dout_tmp));
  defparam cpu_scm.mem_file = mem_file;

  //if (load_byte == 1'b1) begin
  //   assign dout_tmp = { {24 {1'b0}}, dout_tmp[0:7]};
  //end
   
   
   
   
  generate 
  genvar index;
  for (index=0; index < 32; index = index + 1)
	begin
        dff reg32_Mem (.clk(clk), .d(dout_tmp[index]), .q(dout[index]));
	end
  endgenerate

   assign dout_mem = dout_tmp;
   
  generate 
  genvar i;
  for (i=0; i< 32; i = i + 1)
	begin
        dff reg32_result (.clk(clk), .d(addr[i]), .q(result_mem[i]));
	end
  endgenerate
  not_gate not0 (.x(init_delay),.z(invinit_delay));
  or_gate or0 (.x(init_delay),.y(newRegWrite_ex),.z(finalnewRegWrite_ex));
  dff reg_MemtoReg (.clk(clk), .d(MemtoReg_ex), .q(MemtoReg_mem));
  dff reg_RegWrite (.clk(clk), .d(RegWrite_ex), .q(RegWrite_mem));
  dff reg_Branch_mem0 (.clk(clk), .d(Branch_ex), .q(Branch_mem));
  dff reg_Branch_mem1 (.clk(clk), .d(Branch_mem), .q(Branch_mem_delay0));
  dff reg_Branch_mem2 (.clk(clk), .d(Branch_mem_delay0), .q(Branch_mem_delay1));
  assign stall = Branch_mem | Branch_mem_delay0 | Branch_mem_delay1;
  and_gate and0 (.x(stall), .y(invinit_delay), .z(stall_new));
  assign Branch_stall_forwarding = stall_new;
  mux mux_stall0 (.sel(stall), .src0(we), .src1(1'b0), .z(we_new));
  mux mux_stall1 (.sel(stall), .src0(RegWrite_ex), .src1(1'b0), .z(newRegWrite_ex));
  generate 
  genvar j;
  for (j=0; j < 5; j = j + 1)
	begin
        dff reg_towrite (.clk(clk), .d(towrite_ex[j]), .q(towrite_mem[j]));
	end
  endgenerate
endmodule
