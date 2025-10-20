`timescale 1ns/1ps

module comparador2bits (
    input [1:0] a, b,
    output y
);

reg y_comp;

always @(*) begin
    if (a == b)
        y_comp = 1;
    else
        y_comp = 0;
end

assign y = y_comp;

endmodule

// comparador2bits_tb.v
module comparador_tb;
reg [1:0] a, b;
wire y;

comparador2bits dut(.a(a), .b(b), .y(y));

always #1 b[0] = !b[0];
always #2 b[1] = !b[1];
always #4 a[0] = !a[0];
always #8 a[1] = !a[1];

initial begin
    $display("a[1] | a[0] | b[1] | b[0] | y");
    $monitor("%4d | %4d | %4d | %4d | %b", a[1], a[0], b[1], b[0], y);
    a = 2'b00;
    b = 2'b00;
    #16 $finish;
end

endmodule