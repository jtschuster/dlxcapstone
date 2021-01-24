module DataPath(addr_inst_tb, opcode_tb, func_tb, Rs_tb, Rt_tb, Rd_tb);


//TO DEBUG AND SEE THE EACH CONTROL SIGNAL IN THE PORTS:
//(addr_inst_tb, opcode_tb, func_tb, Rs_tb, Rt_tb, Rd_tb, shamt_tb, 
//imm16_tb, RegWr_tb, RegDst_tb, busA_tb, busB_tb, busW_tb,BranchNE_tb,BranchE_tb,BranchTZ_tb, 
//MemtoReg_tb, MEM_out_tb, ALU_out_tb, MemRead_tb, clk_tb_wave, clk_lw_wave, rst_tb_wave, BTZ_out_tb, 
//Btemp_tb, B_out_tb, ALUop_tb);
    
    
    // input clk_tb;
    // input rst_tb;
    // input clk_lw;
     output wire [31:0] addr_inst_tb;
     output wire [5:0] opcode_tb;
     output wire [5:0] func_tb;
     output wire [4:0] Rs_tb;
     output wire [4:0] Rt_tb;
     output wire [4:0] Rd_tb;
    // output wire [4:0] shamt_tb;
    // output wire [15:0] imm16_tb;
    // output wire RegWr_tb;
    // output wire RegDst_tb;
    // output wire [31:0] busA_tb;
    // output wire [31:0] busB_tb;
    // output wire [31:0] busW_tb;
    // output wire BranchNE_tb;
    // output wire BranchE_tb;
    // output wire BranchTZ_tb;
    // output wire MemtoReg_tb;
    // output wire [31:0] MEM_out_tb;
    // output wire [31:0] ALU_out_tb;
    // output wire MemRead_tb;
    // output wire clk_tb_wave;
    // output wire clk_lw_wave;
    // output wire rst_tb_wave;
    // output wire BTZ_out_tb;
    // output wire Btemp_tb;
    // output wire B_out_tb;
    // output wire [2:0] ALUop_tb;
            
    
    wire [31:0] addr_inst;
    
    wire [5:0] opcode;
    wire [5:0] func;
    wire [4:0] Rs;
    wire [4:0] Rt;
    wire [4:0] Rd;
    wire [4:0] shamt;
    wire [15:0] imm16;
    // reg file
    wire RegWr;
    wire RegDst;
    wire [31:0] busA;
    wire [31:0] busB;
    wire [31:0] busW;
    //control unit 
    wire [2:0] ALUop;
    wire BranchNE;
    wire BranchE;
    wire BranchTZ;
    wire Nzero;
    wire ze_out;
    wire Bne_out;
    wire Be_out;
    wire B_out;
    wire BTZ_out;
    wire BTZ_out_1;
    wire Btemp;
    //alu control
    wire [31:0] imm16_out_ex;
    wire [31:0] imm16_out_signex;
    
    wire ExtOp;
    wire [31:0] z_MUX_Extender;
    wire ALUSrc;
    wire [31:0] z_MUX_ALUSrc;
    wire [31:0] nothing;
    //ALU
    wire [2:0] ALUctrl;
    wire ALU_Z;
    wire ALU_cout;
    wire ALU_OVF;
    wire ALU_cout_not;
    wire [31:0] ALU_out;
    // mem
    wire MemWrite;
    wire MemRead;
    wire [31:0] MEM_out;
    // mux mem to reg
    wire MemtoReg;
    
    reg clk_tb = 1'b0;
    reg clk_lw = 1'b0;
    reg rst_tb;
    
    assign nothing = 32'h00000000;
    
    inst_mem inst_mem_map(.Adr(addr_inst), .opcode(opcode), .func(func), .Rs(Rs), .Rt(Rt), .Rd(Rd), .shamt(shamt), .imm16(imm16));
    
    next_address_logic next_logic(.clk(clk_tb), .branch(B_out), .zero(B_out), .rst(rst_tb), .instruction(imm16), .addr(addr_inst));
    
    // Adr, opcode,func, Rs, Rt, Rd, shamt, imm16
    
    
    ControlUnit CU_map(.OPcode(opcode), .ALUOp(ALUop), .RegDst(RegDst), .ALUSrc(ALUSrc), .MemToReg(MemtoReg), .RegWrite(RegWr), .MemRead(MemRead), .MemWrite(MemWrite), .BranchNE(BranchNE), .Branch(BranchE), .BranchTZ(BranchTZ), .ExtOP(ExtOp));
    
    not_gate not_gate_map(.x(ALU_Z), .z(Nzero));
    not_gate not_gate_map1(.x(ALU_cout), .z(ALU_cout_not));
    and_gate AND2_1(.x(BranchNE), .y(Nzero), .z(Bne_out));
    and_gate AND2_2(.x(BranchE), .y(ALU_Z), .z(Be_out));
    and_gate AND2_3(.x(BranchTZ), .y(ALU_cout_not), .z(BTZ_out_1));
    and_gate AND2_4(.x(BTZ_out_1), .y(Nzero), .z(BTZ_out));
    
    or_gate OR1(.x(Bne_out), .y(Be_out), .z(Btemp));
    or_gate OR1_2(.x(BTZ_out), .y(Btemp), .z(B_out));
    or_gate OR2(.x(Nzero), .y(ALU_Z), .z(ze_out));
    
    ALUCU ALUCU_map(.ALUOp(ALUop), .func(func), .ALUCtr(ALUctrl));
    
    RegFile reg_map(.clk(clk_tb), .arst(rst_tb), .aload(1'b0), .busW(busW), .RegWr(RegWr), .RegDst(RegDst), .Rs(Rs), .Rt(Rt), .Rd(Rd), .busA(busA), .busB(busB));
    
    Extender exe_map(.imm16(imm16), .out(imm16_out_ex));
    sign_ext SignEx_map(.imm16(imm16), .out(imm16_out_signex));
    
    mux_32 mux_extender(.sel(ExtOp), .src0(imm16_out_ex), .src1(imm16_out_signex), .z(z_MUX_Extender));
    mux_32 mux_ALUsrc(.sel(ALUSrc), .src0(busB), .src1(z_MUX_Extender), .z(z_MUX_ALUSrc));
    
    ALU alu_map(.ctrl(ALUctrl), .A(busA), .B(z_MUX_ALUSrc), .shamt(shamt), .cout(ALU_cout), .ovf(ALU_OVF), .ze(ALU_Z), .R(ALU_out));
    //clk, MemWr, output_en, data_in, address, data_out
    data_mem data_mem_map(.clk(clk_lw), .MemWr(MemWrite), .output_en(MemRead), .data_in(busB), .address(ALU_out), .data_out(MEM_out));
    
    mux_32 mux_memtoReg(.sel(MemtoReg), .src0(ALU_out), .src1(MEM_out), .z(busW));
    
   
    //TO DEBUG AND SEE THE EACH CONTROL SIGNAL IN THE PORTS:
     assign addr_inst_tb = addr_inst;
     assign opcode_tb = opcode;
     assign func_tb = func;
     assign Rs_tb = Rs;
     assign Rt_tb = Rt;
     assign Rd_tb = Rd;
    // assign shamt_tb = shamt;
    // assign imm16_tb = imm16;
    // assign RegWr_tb = RegWr;
    // assign RegDst_tb = RegDst;
    // assign busA_tb = busA;
    // assign busB_tb = busB;
    // assign busW_tb = busW;
    // assign BranchNE_tb = BranchNE;
    // assign BranchE_tb = BranchE;
    // assign BranchTZ_tb = BranchTZ;
    // assign MemtoReg_tb = MemtoReg;
    // assign MEM_out_tb = MEM_out;
    // assign ALU_out_tb = ALU_out;
    // assign MemRead_tb = MemRead;
    // assign clk_tb_wave = clk_tb;
    // assign clk_lw_wave = clk_lw;
    // assign rst_tb_wave = rst_tb;
    // assign BTZ_out_tb = BTZ_out;
    // assign Btemp_tb = Btemp;
    // assign B_out_tb = B_out;
    // assign ALUop_tb = ALUop;
     
     
  
 //  always @(clk_tb,rst_tb, clk_lw) begin
//  $display("address: %b", addr_inst);
//  $display("opcode: %b", opcode);
//  $display("clk_tb: %b", clk_tb);
//  $display("rst_tb: %b", rst_tb);
//  $display("clk_lw: %b", clk_lw);
//  $display("imm16: %b", imm16);
//  $display("busA: %b", busA);
//  $display("busB: %b", busB);
//  $display("ALU_out: %b", ALU_out);
//  $display("busW: %b", busW);
//  $display("MemtoReg: %b", MemtoReg);
//  $display("MEM_out: %b", MEM_out);
//  $display("z_MUX_ALUSrc: %b", z_MUX_ALUSrc);
 // $display("ALU_ctrl: %b", ALUctrl);
  
 //  end
    
    initial begin
       rst_tb <= 1'b1;
       #1
       rst_tb <= 1'b0;
       
   end
   always
       #2
       clk_tb = !clk_tb;
   
   always 
       #1
       clk_lw = !clk_lw;
   
   
   
   endmodule
       
        
    
    
    
    
    
    
    
