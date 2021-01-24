module instruction_decoder(x, opcode, rs, rt, rd, shamt, funct, addr);
    
    input [31:0] x;
    output wire [5:0] opcode;
    output wire [4:0] rs;
    output wire [4:0] rt;
    output wire [4:0] rd;
    output wire [4:0] shamt;
    output wire [5:0] funct;
    output wire [15:0] addr;
    
    assign opcode = x[31:26];
    assign rs = x[25:21];
    assign rt = x[20:16];
    assign rd = x[15:11];
    assign shamt = x[10:6];
    assign funct = x[5:0];
    assign addr = x[15:0];
    
endmodule
    
    
