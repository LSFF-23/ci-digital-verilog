module tb_ula_ccr;
reg signed [7:0] A, B;
reg [2:0] opcode;
wire signed [7:0] C;
wire overflow, halfcarry, carry, igual, menor, maior, negativo, zero;

ula_ccr dut (
    A, B, opcode, C, 
    {overflow, halfcarry, carry, igual, menor, maior, negativo, zero}
);

initial begin
    // 0 + 0 = 0 (zero = 1)
    A = 0; B = 0; opcode = 3'b000; #10
    // 1 + 0 = 1 (zero = 0)
    A = 1; #10
    // 3 - 4 = -1 (negativo = 1)
    A = 3; B = 4; opcode = 3'b001; #10
    // 3 - 2 = 1 (negativo = 0)
    B = 2; #10
    // 5 > 4 (maior = 1, menor = 0, igual = 0)
    A = 5; B = 4; opcode = 3'b001; #10
    // 3 < 4 (maior = 0, menor = 1, igual = 0)
    A = 3; #10
    // 4 = 4 (maior = 0, menor = 0, igual = 1)
    A = 4; #10
    // -1 (255) + 1 (carry = 1)
    A = -1; B = 1; opcode = 3'b000; #10
    // 1 + 15 (half-carry = 1)
    A = 1; B = 15; #10
    // 64 * 2 = 128 (overflow = 1)
    A = 64; B = 2; opcode = 3'b010; #10
    // -64 * 2 = -128 (overflow = 0)
    A = -64; #10
    // 127 * 127 (overflow = 1)
    A = 127; B = 127; #10
    $stop(0);
end


endmodule