module sign_ext(imm16, out);
    input [15:0] imm16;
    output wire [31:0] out;
    
    wire and_out;
    
    and_gate ext(.x(imm16[15]), .y(1'b1), .z(and_out)); 
    
    assign out[15:0] = imm16[15:0];
   assign out[16] = and_out;
   assign  out[17] = and_out;
   assign  out[18] = and_out;
   assign  out[19] = and_out;
   assign  out[20] = and_out;
   assign  out[21] = and_out;
   assign  out[22] = and_out;
   assign  out[23] = and_out;
   assign  out[24] = and_out;
   assign  out[25] = and_out;
   assign  out[26] = and_out;
   assign  out[27] = and_out;
   assign  out[28] = and_out;
   assign  out[29] = and_out;
   assign  out[30] = and_out;
   assign  out[31] = and_out;

endmodule
    
