module bcd2xs3 (
    input a, b, c, d,
    output w, x, y, z
);

assign w = a | b & d | b & c;
assign x = !b & d | !b & c | b & !c & !d;
assign y = !c & !d | c & d;
assign z = !d;

endmodule

module bcd2xs3_tb;
reg a, b, c, d;
wire w, x, y, z;

bcd2xs3 dut (a, b, c, d, w, x, y, z);

initial begin
    $display("ABCD | WXYZ");
    $monitor("%b%b%b%b | %b%b%b%b", a, b, c, d, w, x, y, z);
    {a,b,c,d} = 4'b0000; #10;
    {a,b,c,d} = 4'b0001; #10;
    {a,b,c,d} = 4'b0010; #10;
    {a,b,c,d} = 4'b0011; #10;
    {a,b,c,d} = 4'b0100; #10;
    {a,b,c,d} = 4'b0101; #10;
    {a,b,c,d} = 4'b0110; #10;
    {a,b,c,d} = 4'b0111; #10;
    {a,b,c,d} = 4'b1000; #10;
    {a,b,c,d} = 4'b1001; #10;
end

endmodule