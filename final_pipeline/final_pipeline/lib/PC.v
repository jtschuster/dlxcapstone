// PC
// CurrPC should be the PC that goes into SRAM, not PC+4
// stall will come from the control in the ID stage, should be able to be connected to "kill_next_instruction"
module PC (clk, CurrPC, Branch, BranchPC, stall, NextPC);
   input clk, Branch, stall;
   input [31:0]  CurrPC, BranchPC;
   output [31:0] NextPC;
   reg [31:0] 	 nextPc;
   initial begin
      nextPc = 32'h00000000;
   end
   assign NextPC = nextPc;
   always @(negedge clk) begin
      if (Branch == 1) begin 
	 nextPc <= BranchPC;
      end
      else if (stall == 1) begin
	 nextPc <= CurrPC;
      end
      else begin
	 nextPc <= CurrPC + 4;
      end
   end // always @ (negedge clk)
endmodule
