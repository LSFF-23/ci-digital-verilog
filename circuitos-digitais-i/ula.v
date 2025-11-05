module ula (
    input [3:0] A,       // Operando A
    input [3:0] B,       // Operando B
    input [2:0] seletor, // Sinal de seleção (3 bits)
    output reg [3:0] resultado // Resultado da operação
);

    // Descrição comportamental
    always @(*) begin
        case (seletor)
            3'b000: resultado = A & B;
            3'b001: resultado = A | B;
            3'b010: resultado = ~A;         // Operação NOT (aplica-se apenas ao operando A)
            3'b011: resultado = ~(A & B);
            3'b100: resultado = A + B;
            3'b101: resultado = A - B;
            default: resultado = 4'b0000;   // Resultado zero
        endcase
    end

endmodule

module ula_tb;
reg [3:0] a, b;
reg [2:0] sel;
wire [3:0] result;

ula dut (a, b, sel, result);

initial begin
    $display("sel |   a  |   b  | result");
    $monitor("%b | %b | %b | %6b", sel, a, b, result);
    sel = 0; a = 4'b1111; b = 4'b1010;
    #1 sel = 1; a = 4'b0000; b = 4'b0101;
    #1 sel = 2; a = 4'b0011; b = 4'bx;
    #1 sel = 3; a = 4'b1100; b = 4'b0011;
    #1 sel = 4; a = 4'b1001; b = 4'b0100;
    #1 sel = 5; a = 4'b1111; b = 4'b0111;
    #1 $finish(0);
end

endmodule