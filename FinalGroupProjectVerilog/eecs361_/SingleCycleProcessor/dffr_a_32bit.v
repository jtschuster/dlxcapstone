module dffr_a_32bit (clk, arst, aload, adata, d, enable, q);
    input clk;
    input arst;
    input aload;
    input [31:0] adata;
    input [31:0] d;
    input enable;
    output reg [31:0] q;
    
    always @(clk or arst or aload)
      begin
        if (arst == 1'b1) q <= 32'h00000000;
        else if (aload == 1'b1) q <= adata; 
        else if ((clk == 1'b1) && (enable == 1'b1)) q <= d;
      end
      
endmodule 
          
    
