module alu(A, B, Op, Carryout, Overflow, Zero, Result, Set);

input   [31:0] A;
input   [31:0] B;
input   [4:0] Op;
output  Carryout;
output  Overflow;
output  Zero;
output  [31:0] Result;
output  Set;

reg Zero;
reg [31:0] Result;
reg Set;

wire [31:0] sub_result;
wire [31:0] add_result;
wire [32:0] tmp;
wire [30:0] add_lower_bits;
wire add_carry_1;
wire add_carry_2;

assign sub_result = A - B;
assign add_result = A + B;
// Carryout
assign tmp = {1'b0,A} + {1'b0,B};
assign Carryout = tmp[32];
// Overflow 
assign {add_carry_1, add_lower_bits} = A[30:0] + B[30:0];
assign {add_carry_2, add_result} = A + B;
assign Overflow = add_carry_1 ^ add_carry_2;

always @(*) begin
    case(Op)
        5'b00000: begin  // and
            Result      <= A & B;
            Set         <= 1'b0;

        end
        5'b00001: begin  // or
            Result      <= A | B;
            Set         <= 1'b0;

        end
        5'b00010: begin  // add
            Result      <= A + B;
            Set         <= 1'b0;
	end
        5'b00011: begin  // sub
            Result      <= A - B;
            Set         <= 1'b0;
	end
        5'b00100: begin  // xor
            Result      <= A ^ B;
            Set         <= 1'b0;
	end
        5'b00101: begin  // sll
            Result      <= A << B;
            Set         <= 1'b0;
	end
        5'b00110: begin  // srl
            Result      <= A >> B;
            Set         <= 1'b0;
	end
        5'b00111: begin  // sltu
            if (A < B) begin
                Set         <= 1'b1;
            end
            else begin
                Set         <= 1'b0;
            end
            Result      <= sub_result;
	end
        5'b01000: begin  // slt
            if (sub_result[31]) begin
                Set         <= 1'b1;
            end
            else begin
                Set         <= 1'b0;
            end
            Result      <= sub_result;
	end

        5'b01001: begin  // sge
            if (sub_result[31]) begin
                Set         <= 1'b0;
            end
            else begin
                Set         <= 1'b1;
            end
            Result      <= sub_result;
	end

        default: begin
            Result      <= A + B;
            Set         <= 1'b0;

        end
    endcase

end

always @(*) begin
    if (Result == 0) begin
        Zero <= 1'b1;
    end
    else begin
        Zero <= 1'b0;
    end
end

endmodule
