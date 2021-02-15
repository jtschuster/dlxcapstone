module RegisterFiles_tb;
  
  reg t_clk;
  reg t_we;
  reg [4:0] t_rR1,t_rR2, t_wR;
  reg [31:0] t_data;
  wire [31:0] t_dout1,t_dout2;
  
  
  
  RegisterFiles reg_tb (.clk(t_clk), .writenable(t_we), .rs1_sel(t_rR1), .rs2_sel(t_rR2),
		.writesel(t_wR),.Din(t_data), .rs1_out(t_dout1), .rs2_out(t_dout2));
  
  initial
    begin
      $monitor(t_clk , t_we , t_rR1 , t_rR2 , t_wR , t_data , t_dout1, t_dout2);
      
      t_clk = 1'b0;
      t_we = 1'b1;
      t_wR = 5'b00001;
      t_data = 32'h8421;
      t_rR1 = 5'b00001;
      t_rR2 = 5'b11111;
      #10
      t_clk = 1'b1;
      t_we = 1'b1;
      
      #10
      t_clk = 1'b0;
      t_we = 1'b1;
      t_wR = 5'b00000;
      t_data = 32'h1248;
      #10
      t_clk = 1'b1;
      t_we = 1'b1;
      
      
      #10
      t_clk = 1'b0;
      t_we = 1'b1;
      t_rR1 = 5'b00001;
      t_rR2 = 5'b00000;
       t_wR <= 5'b00000;
      #10
	t_clk = 1;
       #10
	 t_clk = 0;
      $stop;
     
  end
  
endmodule
