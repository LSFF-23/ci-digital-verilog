module bcd_mult (
    input [3:0] a, b,
    output [3:0] d2, d1, d0
);

reg [7:0] mul, factor;
reg [3:0] d2_r, d1_r, d0_r;

always @(*)
begin
    mul = a*b;
    factor = 8'd100;
    d2_r <= mul/factor;
    mul = mul%factor;
    factor = 8'd10;
    d1_r <= mul/factor;
    mul = mul%factor;
    d0_r <= mul;
end

assign d2 = d2_r;
assign d1 = d1_r;
assign d0 = d0_r;

endmodule

module decoder (
    input [3:0] bcd, // Entrada BCD (4 bits: D C B A)
    output reg [6:0] segments // Saída para os 7 segments (a g f e d c b)
);
    // Mapeamento dos segments:
    // Posição: 6  5  4  3  2  1  0
    // Segmento: a  b  c  d  e  f  g
    // (A ordem pode variar, ajuste se necessário)
    
    always @(*) begin
        case (bcd)
            4'b0000: segments = 7'b0000001; // 0
            4'b0001: segments = 7'b1001111; // 1
            4'b0010: segments = 7'b0010010; // 2
            4'b0011: segments = 7'b0000110; // 3
            4'b0100: segments = 7'b1001100; // 4
            4'b0101: segments = 7'b0100100; // 5
            4'b0110: segments = 7'b0100000; // 6
            4'b0111: segments = 7'b0001111; // 7
            4'b1000: segments = 7'b0000000; // 8
            4'b1001: segments = 7'b0000100; // 9
            
            // Para entradas BCD inválidas (A, B, C, D, E, F)
            default: segments = 7'b1111111; // Apaga tudo
        endcase
    end
endmodule

module seg_mult (a, b, d2, d1, d0);
input [3:0] a, b;
output [6:0] d2, d1, d0;

wire [3:0] d2_w, d1_w, d0_w;

bcd_mult I1 (.a(a), .b(b), .d2(d2_w), .d1(d1_w), .d0(d0_w));
decoder D2 (.bcd(d2_w), .segments(d2));
decoder D1 (.bcd(d1_w), .segments(d1));
decoder D0 (.bcd(d0_w), .segments(d0));

endmodule

module bcd_tb;
reg [3:0] a,b;
wire [6:0] d2, d1, d0;

seg_mult dut(.a(a), .b(b), .d2(d2), .d1(d1), .d0(d0));

initial begin
    /*
    $display("  a  |  b  | d2 | d1 | d0");
    $monitor(" %3d | %3d | %d | %d | %d", a, b, d2, d1, d0);
    #0 a = 4'd0; b = 4'd0;
    #1 a = 4'd5; b = 4'd5;
    #2 a = 4'd10; b = 4'd15;
    #3 a = 4'd15; b = 4'd15;
    #4 $finish;
    */
    $display("   a |   b | d2'0000000 | d1'0000000 | d0'0000000");
    $monitor(" %3d | %3d | %10b | %10b | %10b", a, b, d2, d1, d0);
    #0 a = 4'd0; b = 4'd0;
    #1 a = 4'd5; b = 4'd5;
    #2 a = 4'd10; b = 4'd15;
    #3 a = 4'd15; b = 4'd15;
    #4 $finish;
end

endmodule