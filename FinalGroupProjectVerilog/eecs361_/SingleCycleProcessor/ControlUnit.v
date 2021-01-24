module ControlUnit(OPcode, ALUOp, RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, BranchNE, Branch, BranchTZ ,ExtOP);
    
    input [5:0] OPcode;
    output wire [2:0] ALUOp;
    output RegDst;
    output ALUSrc;
    output MemToReg;
    output RegWrite;
    output MemRead;
    output MemWrite;
    output BranchNE;
    output Branch;
    output BranchTZ;
    output ExtOP;
    
    wire R_type;
    wire LW ;
    wire SW;
    wire BEQ;
    wire BNEQ;
    wire BGTZ;
    wire addi;
    
    
    assign R_type = (OPcode == 6'b000000) ? 1'b1:1'b0;
    assign LW = (OPcode == 6'b100011) ? 1'b1:1'b0;
    assign SW = (OPcode == 6'b101011) ? 1'b1:1'b0;
    assign BEQ = (OPcode == 6'b000100) ? 1'b1:1'b0;
    assign BNEQ = (OPcode == 6'b000101) ? 1'b1:1'b0;
    assign BGTZ = (OPcode == 6'b000111) ? 1'b1:1'b0;
    assign addi = (OPcode == 6'b001000) ? 1'b1:1'b0;
      
    assign Branch = BEQ;
    assign BranchNE = BNEQ;
    assign BranchTZ = BGTZ;
   
    assign MemToReg = LW;
   
    assign ALUSrc = (LW | SW| addi); 
   
   assign RegDst = R_type;
   assign MemRead = LW;
   assign MemWrite = SW;
   assign RegWrite = (R_type | LW | addi);
   
   assign ExtOP = (LW | SW);
   
   assign ALUOp[2] = R_type;
   assign ALUOp[1] = addi;
   assign ALUOp[0] = (BEQ | BNEQ | BGTZ);
   
   // For debugging
   //  always @* begin
   //     $display ("--CONTROL UNIT--");
    //    $display("Opcode %b", OPcode);
   //     $display ("R_type %h ", R_type );
    //    $display ("LW %h ", LW );
   //     $display ("SW %h ", SW );
    //    $display ("Branch %b ", Branch );
   //      $display ("BranchNE %b ", BranchNE );
   //      $display ("BranchTZ %b ", BGTZ );
    //    $display ("RegWrite %b ", RegWrite );
     //    $display ("----------------");
    //  end
   

endmodule
    
    
   
   
