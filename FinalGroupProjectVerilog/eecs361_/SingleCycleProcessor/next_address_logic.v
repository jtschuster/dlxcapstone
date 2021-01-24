module next_address_logic(clk, branch, zero, rst, instruction, addr);
    input clk;
    input branch;
    input zero;
    input rst;
    input [15:0] instruction;
    output wire [31:0] addr;
    
    
    wire [31:0] pc_out;
    wire [31:0] adder_out1;
    wire [31:0] adder_out2;
    wire [31:0] adder_out3;
    wire [31:0] mux_out ;
    wire [31:0] sign_out ;
    wire [31:0] zero1 ;
    
    wire ctrl_out;
    wire [31:0] shift_sign;
    
    assign zero1 = 32'h00000000;
    
    
    
    sign_ext sign_unit(.imm16(instruction), .out(sign_out));
    
    assign shift_sign[31:2] = sign_out[29:0];
    assign shift_sign[1:0] = 2'b00;
    
    
    and_gate ctrl_unit(.x(branch), .y(zero), .z(ctrl_out));
    
    pc pc_unit(.clk(clk), .in(mux_out), .out(pc_out), .rst(rst));
    
    adder_32 adder1(.a(pc_out), .b(32'h00000004), .z(adder_out1));
    adder_32 adder2(.a(adder_out1), .b(shift_sign), .z(adder_out2));
    
    mux_32 mux_unit(.sel(ctrl_out), .src0(adder_out1), .src1(adder_out2), .z(mux_out));
    
    
    assign addr = pc_out;
    
    // For Debugging
    //always @(pc_out, adder_out1, adder_out2, clk, instruction) begin
    //   $display ("--NEXT ADDRESS LOGIC--");
    //   $display ("pc_out %h ", pc_out );
    //   $display ("adder_out1 %h ", adder_out1 );
    //   $display ("adder_out2 %h ", adder_out2 );
    //   $display ("clk %b ", clk );
    //    $display ("rst %b ", rst );
    //    $display ("branch %b ", branch );
    //   $display ("instruction %b ", instruction );
    //    $display ("----------------");
    // end
    
endmodule
