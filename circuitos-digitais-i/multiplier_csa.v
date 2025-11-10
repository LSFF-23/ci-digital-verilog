module parameterized_csa #(parameter N = 4) (A, B, Cin, Sum, Cout);
    input [N-1:0] A, B, Cin;
    output [N-1:0] Sum, Cout;
    assign Sum  = A ^ B ^ Cin;               // Soma
    assign Cout = (A & B) | (B & Cin) | (Cin & A);   // Carry
endmodule


// Modulo Multiplicador usando CSA simplificado com apenas dois CSAs
module multiplier_csa #(parameter WIDTH = 4) (
    input  [WIDTH-1:0] multiplicand,
    input  [WIDTH-1:0] multiplier,
    output [2*WIDTH-1:0] product
);

    wire [2*WIDTH-1:0] partial_products [WIDTH-1:0];   // Produtos parciais estendidos
    wire [2*WIDTH-1:0] sum_stage1, sum_stage2;          // Somadores parciais
    wire [2*WIDTH-1:0] carry_stage1, carry_stage2;      // Carrys parciais

    // Geracao dos produtos parciais
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = multiplier[i] ? (multiplicand << i) : 0;
        end
    endgenerate

    // Primeira etapa: somar os primeiros dois produtos parciais
    parameterized_csa #(2*WIDTH) csa_stage1 (
        .A(partial_products[0]),
        .B(partial_products[1]),
        .Cin(partial_products[2]),
        .Sum(sum_stage1),
        .Cout(carry_stage1)
    );

    // Segunda etapa: somar os resultados intermediarios
    parameterized_csa #(2*WIDTH) csa_stage2 (
        .A(partial_products[3]),
        .B(sum_stage1),
        .Cin(carry_stage1 << 1),
        .Sum(sum_stage2),
        .Cout(carry_stage2)
    );

    // Produto final
    assign product = sum_stage2 + (carry_stage2 << 1); // Concatena soma e carry diretamente
endmodule

// Test bench
module multiplier_csa_tb;
reg  [3:0] multiplicand;
reg  [3:0] multiplier;
wire [7:0] product;

// Instancia do multiplicador
multiplier_csa #(4) uut (
    .multiplicand(multiplicand),
    .multiplier(multiplier),
    .product(product)
);

initial begin
    // Testar combinacoes de entradas
    multiplicand = 4'b0011; // 3
    multiplier = 4'b0101;   // 5
    #10;
    $display("Multiplicand: %d, Multiplier: %d, Product: %d", multiplicand, multiplier, product);
    
    multiplicand = 4'b1111; // 15
    multiplier = 4'b0001;   // 1
    #10;
    $display("Multiplicand: %d, Multiplier: %d, Product: %d", multiplicand, multiplier, product);

    multiplicand = 4'b1011; // 11
    multiplier = 4'b1111;   // 15
    #10;
    $display("Multiplicand: %d, Multiplier: %d, Product: %d", multiplicand, multiplier, product);

    multiplicand = 4'b1111; // 15
    multiplier = 4'b1111;   // 15
    #10;
    $display("Multiplicand: %d, Multiplier: %d, Product: %d", multiplicand, multiplier, product);

    $finish;
end
endmodule