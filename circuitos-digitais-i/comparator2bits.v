module comparator2bits (
    input [1:0] a, b,
    output y
);

assign y = !(a^b);

endmodule

module comparador_tb;
reg [1:0] a, b;
wire y;

comparator2bits dut(.a(a), .b(b), .y(y));

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