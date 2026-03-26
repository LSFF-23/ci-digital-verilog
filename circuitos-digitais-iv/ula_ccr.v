module ula_ccr (
    input signed [7:0] A, B,
    input [2:0] opcode,
    output signed [7:0] C,
    output [7:0] CCR
);

wire [8:0] sum = {1'b0, A} + {1'b0, B};
wire sum_carry = sum[8];
wire [4:0] nibble_sum = {1'b0, A[3:0]} + {1'b0, B[3:0]};
wire nibble_carry = nibble_sum[4];

wire [8:0] sub = {A[7], A} - {B[7], B};

wire [15:0] mult = $signed(A) * $signed(B);

wire [7:0] div = (B != 0) ? A / B : 8'b0;

wire [7:0] and_op = A & B;
wire [7:0] or_op = A | B;
wire [7:0] not_op = ~A;
wire [7:0] xor_op = A ^ B;

reg [7:0] result;
assign C = result;
always @* begin
    case (opcode)
        3'b000: result = sum[7:0];
        3'b001: result = sub[7:0];
        3'b010: result = mult[7:0];
        3'b011: result = div;
        3'b100: result = and_op;
        3'b101: result = or_op;
        3'b110: result = not_op;
        3'b111: result = xor_op;
    endcase
end

wire zero = C == 0;
wire negativo = C[7];

wire sum_overflow = (~A[7] & ~B[7] & C[7]) | (A[7] & B[7] & ~C[7]);
wire sub_overflow = (~A[7] & B[7] & C[7]) | (A[7] & ~B[7] & ~C[7]);
wire mult_overflow = ~(&mult[15:7]) & (|mult[15:7]);
wire div_overflow = (B == 0) | (A == 8'h80 & B == 8'hFF);

reg overflow;
always @* begin
    case (opcode)
        3'b000: overflow = sum_overflow;
        3'b001: overflow = sub_overflow;
        3'b010: overflow = mult_overflow;
        3'b011: overflow = div_overflow;
        default: overflow = 1'bx;
    endcase
end

reg maior, menor, igual;
always @* begin
    case (opcode)
        3'b001: begin
            if (C > 0)
                {maior, menor, igual} = 3'b100;
            else if (C < 0)
                {maior, menor, igual} = 3'b010;
            else
                {maior, menor, igual} = 3'b001;
        end
        default: {maior, menor, igual} = 3'bxxx;
    endcase
end

reg carry, halfcarry;
always @* begin
    case (opcode)
        3'b000: begin
            carry = sum_carry;
            halfcarry = nibble_carry;
        end
        default: begin
            carry = 1'bx;
            halfcarry = 1'bx;
        end
    endcase
end

assign CCR = {overflow, halfcarry, carry, igual, menor, maior, negativo, zero};

endmodule