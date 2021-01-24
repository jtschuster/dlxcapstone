module Signextend(Extop, Din, Dout);
  input [15:0] Din;
  input Extop;
  output [31:0] Dout;
  wire temp;
  and_gate se_ag_0 (.x(Extop), .y(Din[15]), .z(temp));
  assign Dout = {{16{temp}}, Din};
endmodule