module carry_look_ahead_adder #(parameter N = 4) (
    input [N-1:0] A,
    input [N-1:0] B,
    input C_in,
    output [N-1:0] S,
    output C_out
);

    wire [N-1:0] G, P;
    wire [N:0] C;

    assign C[0] = C_in;
    assign G = A & B;
    assign P = A | B;

    generate
        genvar i;
        for (i = 1; i <= N; i = i + 1) begin: cla_block
            assign C[i] = G[i-1] | P[i-1] & C[i-1];
        end
    endgenerate

    assign S = A ^ B ^ C[N-1:0];
    assign C_out = C[N];

endmodule


`timescale 1ns / 1ps
module tb_carry_look_ahead_adder;

    reg [3:0] A;
    reg [3:0] B;
    reg C_in;
    wire [3:0] S;
    wire C_out;

    carry_look_ahead_adder dut (
        .A(A),
        .B(B),
        .C_in(C_in),
        .S(S),
        .C_out(C_out)
    );

    initial begin
        $monitor("Tempo: %0t | A = %b | B = %b | C_in = %b | S = %b | C_out = %b", 
                 $time, A, B, C_in, S, C_out);

        A = 4'b1011; B = 4'b1101; C_in = 0; #10;
        A = 4'b0101; B = 4'b0011; C_in = 0; #10;
        A = 4'b1110; B = 4'b0001; C_in = 0; #10;
        A = 4'b1001; B = 4'b0110; C_in = 1; #10;
        A = 4'b1111; B = 4'b1111; C_in = 0; #10;

        $finish;
    end

endmodule
