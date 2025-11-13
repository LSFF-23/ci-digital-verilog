module behave_4bit_carry_lookahead_adder (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    reg [3:0] P;
    reg [3:0] G;
    reg [3:0] C;

    always @(*) begin
        P = A ^ B;
        G = A & B;

        C[0] = Cin;
        C[1] = G[0] | (P[0] & C[0]);
        C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
        C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);

        Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) |
               (P[3] & P[2] & P[1] & G[0]) |
               (P[3] & P[2] & P[1] & P[0] & C[0]);

        Sum = P ^ C;
    end

endmodule

module behave_4bit_carry_lookahead_adder_tb;

    reg [3:0] A;
    reg [3:0] B;
    reg C_in;
    wire [3:0] S;
    wire C_out;

    behave_4bit_carry_lookahead_adder dut (
        .A(A),
        .B(B),
        .Cin(C_in),
        .Sum(S),
        .Cout(C_out)
    );

    initial begin
        $monitor("Tempo: %0t | A = %b | B = %b | C_in = %b | S = %b | C_out = %b",
                 $time, A, B, C_in, S, C_out);

        A = 4'b1011; B = 4'b1101; C_in = 0; #10;
        A = 4'b0101; B = 4'b0011; C_in = 0; #10;
        A = 4'b1001; B = 4'b0110; C_in = 1; #10;
        A = 4'b1111; B = 4'b1111; C_in = 0; #10;

        $finish;
    end

endmodule