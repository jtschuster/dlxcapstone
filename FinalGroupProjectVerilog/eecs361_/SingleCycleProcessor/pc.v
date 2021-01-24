module pc(clk, rst, in, out);
    input clk;
    input rst;
    input [31:0] in;
    output wire [31:0] out;
    
    
    wire [31:0] zero;
    assign zero  = 32'h00400020;

    
    dffr_32bit_PC p_c(.clk(clk), .d(in), .q(out), .arst(rst), .aload(1'b0), .adata(zero), .enable(clk));
   
   endmodule
