`timescale 1ns/10ps

module alu_control_test;
   reg [5:0] func;
   reg [2:0] alu_op;
   wire [2:0] alu_ctr;

   ALUCU alu_control(alu_op, func, alu_ctr);

   initial begin
      alu_op = 3'b000;
      func = 6'b100000;
      #10;
      alu_op = 3'b001;
      #10;
      alu_op = 3'b010;
      #10;
      alu_op = 3'b100;
      func = 6'b100000;
      #10;
      func = 6'b100010;
      #10;
      func = 6'b100100;
      #10;
      func = 6'b100101;
      #10;
      func = 6'b101010;
      #10;

   end // initial begin
endmodule // alu_control_test

