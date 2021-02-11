module sram(cs, oe, we, addr, din, dout);
   parameter mem_file = "../data/unsigned_sum.dat";
   input cs;
   input oe;
   input we;
   input [31:0] addr;
   input [31:0] din;
   output reg [0:31] dout;

   always @ (addr) begin
      case (addr)
	32'h00400020 : begin
	   // addi r1 <= r0 + 0cAAAA
	   // 0x2001AAAA
	   dout[0:31] = 32'b001000_00000_00001_1010_1010_1010_1010;
	end
	32'h00400024 : begin
	   // xor r2 <= r0 ^ r1
	   dout[0:31] = 32'b000000_00000_00001_00010_00000_100110;
	end
	32'h00400028 : begin
	   // subi r2 <= r1 - 0x0A0A
	   dout[0:31] = 32'b001010_00001_00010_0000_1010_0000_1010;
	end
	32'h0040002C : begin
	   // bnez r2, -16 (first instr)
	   dout[0:31] = 32'b000101_00010_00000_1111_1111_1110_1100;
	end
      endcase
   end // always @ (addr)
endmodule // sram
