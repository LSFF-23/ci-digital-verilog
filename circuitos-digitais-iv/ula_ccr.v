module ula_ccr (
    input signed [7:0] A, B,
    input [2:0] opcode,
    output signed [7:0] C,
    output zero, negativo, maior, menor,
    output igual, carry, halfcarry, overflow
);
    reg signed [15:0] result;

assign C = result[7:0];

assign zero = C == 8'b0;
assign negativo = C[7];
assign maior = (opcode == 3'b001) && (C > 8'b0);
assign menor = (opcode == 3'b001) && (C[7]);
assign igual = (opcode == 3'b001) && (C == 8'b0);
assign carry = (opcode == 3'b000) && ((result[8:0] > 127) || (result[8:0]) < -128);
assign halfcarry = (opcode == 3'b000) && result[4];
assign overflow = result[15:8] > 8'b0;

always @* begin
    result = 16'b0;
    case (opcode)
        3'b000: {result[8], result[7:0]} = A + B;
        3'b001: {result[8], result[7:0]} = A - B;
        3'b010: result = A * B;
        3'b011: result[7:0] = A / B;
        3'b100: result[7:0] = A & B;
        3'b101: result[7:0] = A | B;
        3'b110: result[7:0] = ~A;
        3'b111: result[7:0] = A ^ B;
        default: result = 16'b0;
    endcase

end

endmodule