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

integer diff;
integer right_shft;
reg [22:0] A_shfted_mant;
reg [31:0] mantissa;
integer count;

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
	        Result      <= 32'b1;
            end
            else begin
                Set         <= 1'b0;
	        Result      <= 32'b0;
            end
            // Result      <= sub_result;
	end

        5'b01001: begin  // sge
            if (sub_result[31]) begin
                Set         <= 1'b0;
	        Result      <= 32'b0;
            end
            else begin
                Set         <= 1'b1;
	        Result      <= 32'b1;
            end
            // Result      <= sub_result;
	end
	
	5'b01010: begin  // sgt
            if (A > B) begin
                Set         <= 1'b1;
	        Result      <= 32'b1;
            end
            else begin
                Set         <= 1'b0;
	        Result      <= 32'b0;
            end
            // Result      <= A>B;
	end

	5'b01100: begin  // lhi
            Result       <= B << 16;
	    //Should this change Set???
	end

	5'b01111: begin //ADDF
	    if (A == 0 && B == 0) begin
		Result = 0;
	    end
	    else begin
		diff = B[30:23] - A[30:23];
		if (diff > 0) begin
			A_shfted_mant = (32'h800000 >> diff) + (A[22:0] >> diff);
			Result[31] = 1'b0;
			Result[30:23] = B[30:23];
			Result[22:0] = B[22:0] + A_shfted_mant;
		end
		else if (diff < 0) begin
			diff = -diff;
			A_shfted_mant = (32'h800000 >> diff) + (B[22:0] >> diff);
			Result[31] = 1'b0;
			Result[30:23] = A[30:23];
			Result[22:0] = A[22:0] + A_shfted_mant;
		end
	    end
	end

	5'b11111: begin //CVTF2I
	    if (A[30:23] < 127) begin
		Result = 0;
	    end
	    else begin
		right_shft = 150 - A[30:23];
		Result = (32'h800000 >> right_shft) + (A[22:00] >> right_shft);
	    end
	end

	5'b11110: begin //CVTI2F
		mantissa = A;
		count = 0;
		while (!mantissa[31]) begin
			mantissa = mantissa << 1;
			count = count + 1;
		end
		Result[31] = 0;
		Result[30:23] = 158 - count;
		Result[22:0] = mantissa[30:8];
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
