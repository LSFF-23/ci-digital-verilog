module struct_4bit_carry_look_ahead_adder (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [3:0] P;
    wire [3:0] G;
    wire [3:1] C;

    xor (P[0], A[0], B[0]);
    xor (P[1], A[1], B[1]);
    xor (P[2], A[2], B[2]);
    xor (P[3], A[3], B[3]);

    and (G[0], A[0], B[0]);
    and (G[1], A[1], B[1]);
    and (G[2], A[2], B[2]);
    and (G[3], A[3], B[3]);

    wire t1, t2, t3;
    and (t1, P[0], Cin);
    or (C[1], G[0], t1);

    and (t2, P[1], G[0]);
    and (t3, P[1], P[0], Cin);
    or (C[2], G[1], t2, t3);

    wire t4, t5, t6;
    and (t4, P[2], G[1]);
    and (t5, P[2], P[1], G[0]);
    and (t6, P[2], P[1], P[0], Cin);
    or (C[3], G[2], t4, t5, t6);

    wire t7, t8, t9, t10;
    and (t7, P[3], G[2]);
    and (t8, P[3], P[2], G[1]);
    and (t9, P[3], P[2], P[1], G[0]);
    and (t10, P[3], P[2], P[1], P[0], Cin);
    or (Cout, G[3], t7, t8, t9, t10);

    xor (Sum[0], P[0], Cin);
    xor (Sum[1], P[1], C[1]);
    xor (Sum[2], P[2], C[2]);
    xor (Sum[3], P[3], C[3]);

endmodule

`timescale 1ns / 1ps
module struct_4bit_carry_look_ahead_adder_tb;

    reg [3:0] A;
    reg [3:0] B;
    reg C_in;
    wire [3:0] S;
    wire C_out;

    struct_4bit_carry_look_ahead_adder dut (
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
