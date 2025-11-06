module ula_cla (
    input [3:0] A,       // Operando A
    input [3:0] B,       // Operando B
    input cin,
    input [2:0] seletor, // Sinal de seleção (3 bits)
    output reg [3:0] resultado, // Resultado da operação
    output reg P_out, G_out
);

    reg [3:0] P, G;
    integer i;

    // Descrição comportamental
    always @(*) begin
        for (i = 0; i < 4; i = i + 1) begin
            P[i] = A[i]^B[i];
            G[i] = A[i]&B[i];
        end

        P_out = & P;
        G_out = G[3] | P[3] & G[2] | P[3] & P[2] & G[1] | P[3] & P[2] & P[1] & G[0];

        case (seletor)
            3'b000: resultado = A & B;
            3'b001: resultado = A | B;
            3'b010: resultado = ~A;         // Operação NOT (aplica-se apenas ao operando A)
            3'b011: resultado = ~(A & B);
            3'b100: resultado = A + B + cin;
            3'b101: resultado = A - B;
            default: resultado = 4'b0000;   // Resultado zero
        endcase
    end

endmodule

module ula_cla_tb;
reg [3:0] a, b;
reg [2:0] sel;
reg cin;
wire [3:0] result;
wire P, G;

ula_cla dut (a, b, cin, sel, result, P, G);

initial begin
    $display("sel |   a  |   b  | result | cin | P | G");
    $monitor("%b | %b | %b | %6b | %3b | %0b | %0b", sel, a, b, result, cin, P, G);
    sel = 4; a = 4'b1111; b = 4'b1010; cin = 0;
    #1 sel = 4; a = 4'b0000; b = 4'b0101; cin = 1;
    #1 sel = 4; a = 4'b0011; b = 4'b0000; cin = 0;
    #1 sel = 4; a = 4'b1100; b = 4'b0011; cin = 1;
    #1 sel = 4; a = 4'b1001; b = 4'b0100; cin = 0;
    #1 sel = 4; a = 4'b1111; b = 4'b0111; cin = 1;
    #1 $finish(0);
end

endmodule