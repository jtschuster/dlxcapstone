module sram_tb ();
   parameter inst_name = "data/quicksort.dat";
   
   wire [31:0] instruction, instruction2;
   reg [31:0] PC;
   ifetch instr_read (.PC(PC),.instruction(instruction));
   defparam instr_read.inst_name = inst_name;
   sram s_ifetch (.cs(1'b1), .oe(1'b1), .we(1'b0), .addr(PC), .din(32'b0), .dout(instruction2));
   defparam s_ifetch.mem_file = inst_name;

   
   initial begin
      PC = 32'h00;
   end
   
   always begin
      #10 PC <= PC + 4;
      if (PC == 32'hD8) begin
	 $finish;
      end
      
   end
   
endmodule
