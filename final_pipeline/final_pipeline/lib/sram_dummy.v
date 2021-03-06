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
	32'h00: begin
	   // addi r1 <= r0 + 0cAAAA
	   // 0x2001AAAA
	   dout[0:31] = 32'b001000_00000_00001_1010_1010_1010_1010;
	end
	32'h004: begin
	   // mov I -> FP (r1 ->r1fp)
	   dout[0:31] = 32'b000000_00001_00000_00001_00000_11_0101;
	end
	32'h008: begin
	    // mov FP -> I (r1fp ->r1fp3)
	   dout[0:31] = 32'b000000_00001_00000_00011_00000_11_0100;
	end
	/*
	32'h0010: begin
	   // bnez r2, -16 (first instr)
	   dout[0:31] = 32'b000101_00010_00000_1111_1111_1111_0000;
	end
	*/
	32'h0010: begin
	   // jal 100
	   dout[0:31] = 32'b000011_00000_00000_0000_0000_1000_0000;
	end
	32'h00000080: begin
	   dout[0:31] = 32'hF0F077F0;
	end
	
      endcase
   end // always @ (addr)
endmodule // sram
