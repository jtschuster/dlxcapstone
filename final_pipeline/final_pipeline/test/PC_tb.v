module PC_tb ();
   reg clk, Branch, stall;
   wire  [31:0] CurrPC;
   reg [31:0] BranchPC;
   wire [31:0] NextPC;
   reg  [31:0] PC;
   PC test_pc (.clk(clk), .CurrPC(CurrPC), .Branch(Branch), .BranchPC(BranchPC), .stall(stall), .NextPC(NextPC));
   assign CurrPC = NextPC;
   initial begin
      clk = 1;
      Branch = 0;
      stall = 0;
      #25
	BranchPC <= 32'h00400220;
      Branch <= 1;
      #10
	Branch <= 0;
      stall <= 1;
      #10
	stall <= 0;
      #30
	Branch <= 1;
      
   end
   
   always begin
      #5 clk <= !clk;
      #5 clk <= !clk;
   end
//   always @ (NextPC) begin
//      CurrPC <= NextPC;
//   end
endmodule
  
