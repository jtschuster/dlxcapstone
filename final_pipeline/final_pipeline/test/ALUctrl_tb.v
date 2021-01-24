module ALUctrl_tb;
  reg [1:0] ALUop;
  reg [5:0] funct;
  wire [3:0] Control;
  
  ALUctrl DUT (.ALUop(ALUop), .funct(funct), .Control(Control));
  
  initial
  begin
  ALUop = 2'b00;
  funct = 6'b100000;
  #10
  funct = 6'b100001;
  #10
  funct = 6'b100010;
  #10
  funct = 6'b100011;
  #10
  funct = 6'b100100;
  #10
  funct = 6'b100101;
  #10
  funct = 6'b000000;
  #10
  funct = 6'b101010;
  #10
  funct = 6'b101011;
  #10
  ALUop = 2'b01;
  #10
  ALUop = 2'b10;
  #10  
  ALUop = 2'b01;
  #10
  $stop;
  end
endmodule