module bcd2gray (
    input a, b, c, d,
    output w, x, y, z
);

assign w = a;
assign x = !a & b | a & !b;
assign y = !b & c | b & !c;
assign z = !c & d | c & !d;

endmodule

module bcd2gray_tb;
reg a, b, c, d;
wire w, x, y, z;

// para visualização
wire [3:0] bcd, gray;

assign bcd = {a, b, c, d};
assign gray = {w, x, y, z};

bcd2gray dut(a, b, c, d, w, x, y, z);

always #1 d = !d;
always #2 c = !c;
always #4 b = !b;
always #8 a = !a;

initial begin
    $display("ABCD | WXYZ");
    $monitor("%b%b%b%b | %b%b%b%b", a, b, c, d, w, x, y, z);
    {a, b, c, d} = 4'b0000;
    #16 $finish;
end

endmodule