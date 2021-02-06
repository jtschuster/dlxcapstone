// PC
// CurrPC should be the PC that goes into SRAM, not PC+4
// stall will come from the control in the ID stage, should be able to be connected to "kill_next_instruction"
module PC (clk, CurrPC, Branch, BranchPC, stall, NextPC);
   input clk, Branch, stall;
   input [31:0] CurrPC, BranchPC;
   output reg [31:0] NextPC;

   initial begin
      NextPC = 32'h00400020;
   end
   always @(negedge clk) begin
      if (Branch == 1) begin 
	 NextPC <= BranchPC;
      end
      else if (stall == 1) begin
	 NextPC <= CurrPC;
      end
      else begin
	 NextPC <= CurrPC + 4;
      end
   end // always @ (negedge clk)
endmodule
