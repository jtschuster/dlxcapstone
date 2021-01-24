//`timescale lns/1ps;
module ALU_test_pj1;
  reg  [31:0] A;
  reg  [31:0] B;
  reg [3:0] Op;
  wire Carryout;
  wire Overflow;
  wire Zero;
  wire [31:0] Result;
  wire Set;
  alu ALU1 (.A(A), .B(B), .Op(Op), .Carryout(Carryout), .Overflow(Overflow), .Zero(Zero), .Result(Result), .Set(Set));
  

  
  initial
  begin
    // addu 
    A=32'h3f; B=32'hffff; Op=4'b0010; 
    #50
    A=32'h3f; B=32'hffff; Op=4'b0010; 
    #50
    //subu
    A=32'h1fffffff; B=32'h6; Op=4'b0111;
    #50
    A=32'h80000001; B=32'h6; Op=4'b0111;
    #50
    //ADD Overflow
    A=32'h3f; B=32'h7fffffff; Op=4'b0011; 
    #50
    A=32'hffffffff; B=32'h7fffffff; Op=4'b0011; 
    #50
	// SLL
	A=32'haaaaaaaa; B=32'h6; Op=4'b1001; 
    #50
	A=32'haaaaaaaa; B=32'h1f; Op=4'b1001; 
    #50
	//SLL Zero=1
	A=32'h00001000; B=32'h00001000; Op=4'b1001;
    #50
	//SRL
	A=32'haaaaaaaa; B=32'h6; Op=4'b1010; 
    #50
	A=32'haaaaaaaa; B=32'h1f; Op=4'b1010; 
    #50
	//OR
	A=32'hffffffff; B=32'h11; Op=4'b0001; 
    #50
	//OR
	A=32'hffffffff; B=32'hfffaaa11; Op=4'b0001; 
    #50
	//AND
	A=32'hffffffff; B=32'h11; Op=4'b0000; 
    #50
	//AND
	A=32'hfff00001; B=32'h11f; Op=4'b0000; 
    #50
	//XOR
	A=32'hffffffff; B=32'h11; Op=4'b0010; 
    #50
	A=32'hffff0000; B=32'h11; Op=4'b0010; 
    #50
	//SUB 
	A=32'h1fffffff; B=32'h6; Op=4'b0100;
    #50
	//SUB Carryout=1
	A=32'h8fffffff; B=32'h80000000; Op=4'b0100;
    #50

	//SLT SET=1
    A=32'h1aaaaaa1; B=32'h1aaaaaaa; Op=4'b0101; 
    #50
   	//SLT SET=0
    A=32'h2aaaaaaa; B=32'h1aaaaaaa; Op=4'b0101; 
    #50
	//STLU SET=1
	A=32'h80000000; B=32'h80000001; Op=4'b0110;
    #50
        //STLY SET=0 ZERO=1
       	A=32'h80000001; B=32'h80000001; Op=4'b0110;
    #50
	$stop;
  end
endmodule

