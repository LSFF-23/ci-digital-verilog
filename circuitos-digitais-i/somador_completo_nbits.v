module somador_completo_1bit (
    input A,
    input B,
    input Cin,
    output S,
    output Cout
);
    assign S = A ^ B ^ Cin;
    assign Cout = (A & B) | (Cin & (A ^ B));

endmodule


module somador_completo_nbits #(parameter N = 4) (
    input [N-1:0] A,
    input [N-1:0] B,
    input Cin,
    output [N-1:0] S,
    output Cout
);

    wire [N:0] carry;

    generate
        genvar i;
        for (i = 0; i < N; i = i + 1) begin: fa_block
            somador_completo_1bit fa_unit (A[i], B[i], carry[i], S[i], carry[i+1]);
        end
    endgenerate

    assign carry[0] = Cin;
    assign Cout = carry[N];
endmodule

module somador_completo_nbits_tb;
localparam N = 4;
reg [N-1:0] A;
reg [N-1:0] B;
reg Cin;
wire [N-1:0] S;
wire Cout;

somador_completo_nbits#(4) dut (.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout));

initial begin
    $monitor("%2d | %2d | %b | %2d | %b", A, B, Cin, S, Cout);
    A = 5; B = 8; Cin = 0;
    #1 A = 15; B = 1;
    #1 A = 15; B = 15;
    #1 Cin = 1;
    #1 $finish(0);
end

endmodule