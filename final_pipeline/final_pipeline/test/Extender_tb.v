module Signextend_tb;

reg  [15:0] unex;
wire   [31:0] ext;
reg Extop;
Signextend TBSIGNEXT
                  (.Extop(Extop),
                   .Din(unex),
                   .Dout(ext)
                  );


initial 
begin
    Extop = 1'b0;
    unex = 16'h0000;
	#10
        Extop = 1'b1;
    unex = 16'h0000;
	#10
        Extop = 1'b0;
    unex = 16'b1000_0000_1111_1111;
    #10 
        Extop = 1'b1;
    unex = 16'b1000_0000_1111_1111;
    #10
	$stop;
end

endmodule