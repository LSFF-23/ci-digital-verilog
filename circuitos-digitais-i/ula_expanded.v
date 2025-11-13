module ula_expanded (
    input [3:0] A, 
    input [3:0] B, 
    input [3:0] seletor, 
    output reg [3:0] resultado, 
    output reg C, 
    output reg V,
    output reg N, 
    output reg Z  
);

reg [4:0] A_ext, B_ext;
reg [4:0] soma_temp;
reg [4:0] sub_temp;

always @(*) begin
    C = 1'b0;
    V = 1'b0; 

    case (seletor)
        4'b0000: resultado = A & B;
        4'b0001: resultado = A | B;
        4'b0010: resultado = ~A;
        4'b0011: resultado = ~(A & B);
        
        4'b1010: resultado = A ^ B;
        4'b1011: resultado = ~(A | B);

        4'b0100: begin
            soma_temp = {1'b0, A} + {1'b0, B};
            C = soma_temp[4]; 

            A_ext = {{1{A[3]}}, A}; 
            B_ext = {{1{B[3]}}, B}; 
            soma_temp = A_ext + B_ext;

            V = soma_temp[4] ^ soma_temp[3];

            resultado = soma_temp[3:0];
        end

        4'b0101: begin
            sub_temp = {1'b0, A} - {1'b0, B};
            C = ~sub_temp[4]; 

            A_ext = {{1{A[3]}}, A}; 
            B_ext = {{1{B[3]}}, B}; 
            sub_temp = A_ext - B_ext;
            
            V = sub_temp[4] ^ sub_temp[3];

            resultado = sub_temp[3:0];
        end
        
        4'b0110: resultado = A << 1;
        4'b0111: resultado = A >> 1;
        
        4'b1000: resultado = A << (B > 4 ? 4 : B);
        4'b1001: resultado = A >> (B > 4 ? 4 : B);

        default: resultado = 4'b0000;
    endcase

    N = resultado[3]; 
    Z = ~|resultado; 
end

endmodule

module ula_tb;
    reg [3:0] sel;
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] resultado;
    wire C, V, N, Z; 

    ula_expanded ula_instance (
        .A(a), 
        .B(b), 
        .seletor(sel), 
        .resultado(resultado),
        .C(C),
        .V(V),
        .N(N),
        .Z(Z)
    );

    initial begin
        $monitor("%2d | %b | %b | %b | %b | %b | %b | %b | %b |", 
                 $time, sel, a, b, resultado, C, V, N, Z);
        sel = 4'b0000; a = 4'b1111; b = 4'b1010;    // 1111 & 1010 = 1010 (-6)
        #1 sel = 4'b0001; a = 4'b0000; b = 4'b0101; // 0000 | 0101 = 0101 (5)
        #1 sel = 4'b0010; a = 4'b0011; b = 4'bx;    // ~0011 = 1100 (-4)
        #1 sel = 4'b0011; a = 4'b1100; b = 4'b0011; // ~(1100 & 0011) = ~0000 = 1111 (-1)
        #1 sel = 4'b0100; a = 4'b1001; b = 4'b0100; // (9 + 4 = 13)
        #1 sel = 4'b0101; a = 4'b1111; b = 4'b0111; // (15 - 7 = 8)
        #1 sel = 4'b0110; a = 4'b0011; b = 4'b0000; // 0011 << 1 = 0110 (6)
        #1 sel = 4'b0111; a = 4'b1100; b = 4'b0000; // 1100 >> 1 = 0110 (6)
        #1 sel = 4'b1000; a = 4'b0101; b = 4'b0010; // 0101 << 2 = 0100 (4)
        #1 sel = 4'b1001; a = 4'b1000; b = 4'b0001; // 1000 >> 1 = 0100 (4)
        #1 sel = 4'b1010; a = 4'b1111; b = 4'b0101; // 1111 ^ 0101 = 1010 (-6)
        #1 sel = 4'b1011; a = 4'b0001; b = 4'b0110; // ~(0001 | 0110) = ~0111 = 1000 (-8)
        #1 sel = 4'b0100; a = 4'b0111; b = 4'b0001; // 7 + 1 = overflow sinalizado
        #1 sel = 4'b0101; a = 4'b0100; b = 4'b0100; // 4 - 4 = 0
        #1 $finish(0); // Fim da simulação
    end
endmodule