`timescale 1ns/10ps
module ALUCU(ALUOp, func, ALUCtr);
    
    input [2:0] ALUOp;
    input [5:0] func;
    output wire [2:0] ALUCtr;
    
    wire [2:0] ALUCtr_temp;
    wire [2:0] ALUCtr_temp2;
    wire [2:0] ALUCtr_sll;
    wire [2:0] ALUCtr_adu;
	wire [2:0] ALUCtl_slt;
	wire [2:0] ALUCtl_sltu;
    wire [2:0] ALUCtemp;
    wire [2:0] ALUCtremp;
    wire Ffunc;
    wire self;
    wire isslt;
	wire issltu;
	assign issltu = func == 6'd43;
	assign isslt = func == 6'd42;
	assign issubu = func == 6'd35;

    assign Ffunc = (func[5] || func[4] || func[3] || func[2] || func[1] || func[0] || (~ALUOp[2]));
    
    assign ALUCtr_slb = 3'b101;
    
    assign self = (func[5] && (~func[4]) && (~func[3]) && (~func[2]) && (~func[1]) && func[0] && ALUOp[2]);
    
    assign ALUCtr_adu = 3'b010;
	assign ALUCtr_sll = 3'b101;
    assign ALUCtr_subu = 3'd6;

    assign ALUCtr_temp[2] = (((~ALUOp[2]) && ALUOp[0]) || (ALUOp[2] && (~func[2]) && func[1] && (~func[0])));
    assign ALUCtr_temp[1] = (((~ALUOp[2]) && (~(ALUOp[1] && ALUOp[0]))) | (ALUOp[2] && (~func[2]) & (~func[0]))); 
    assign ALUCtr_temp[0] = ((ALUOp[2] && (~func[3]) && func[2] && (~func[1]) && func[0]) || (ALUOp[2] && func[3] && (~func[2]) && func[1] && (~func[0])));
    
    mux_n #(.n(3)) mux_map_0(.sel(Ffunc), .src0(ALUCtr_sll), .src1(ALUCtr_temp), .z(ALUCtremp));
    mux_n #(.n(3)) mux_map_1(.sel(self), .src0(ALUCtremp), .src1(ALUCtr_adu), .z(ALUCtr_temp2));
	wire [2:0] temp1;
	wire [2:0] temp2;
	mux_n #(.n(3)) mux_map_2(.sel(issubu), .src0(ALUCtr_temp2), .src1(ALUCtr_subu), .z(temp1));
    mux_n #(.n(3)) mux_map_3(.sel(isslt), .src0(temp1), .src1(3'd3), .z(temp2));
    mux_n #(.n(3)) mux_map_4(.sel(issltu), .src0(temp2), .src1(3'd7), .z(ALUCtr));
endmodule
