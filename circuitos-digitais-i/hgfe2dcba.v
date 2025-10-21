module hfge2dcba (
    input h, g, f, e,
    output d, c, b, a
);

assign d = h & g;
assign c = (h & !g) | (!h & g & e);
assign b = (!g & f) | (!h & g & !e) | (h & !g);
assign a = (!h & g & !e) | (g & f) | (!h & !g & e & !f) | (h & g);

endmodule

module hfge2dcba_tb;
reg h, g, f, e;
wire d, c, b, a;

hfge2dcba dut (h, g, f, e, d, c, b, a);

/*
always #1 e = !e;
always #2 f = !f;
always #4 g = !g;
always #8 h = !h;
*/

initial begin
    $display("h | g | f | e | d | c | b | a");
    $monitor("%b | %b | %b | %b | %b | %b | %b | %b", h, g, f, e, d, c, b, a);
    /*
    #0 h = 0; g = 0; f = 0; e = 0;
    #16 $finish;
    */
    {h,g,f,e} = 4'b0000; #10;
    {h,g,f,e} = 4'b0001; #10;
    {h,g,f,e} = 4'b0011; #10;
    {h,g,f,e} = 4'b0100; #10;
    {h,g,f,e} = 4'b0101; #10;
    {h,g,f,e} = 4'b0111; #10;
    {h,g,f,e} = 4'b1001; #10;
    {h,g,f,e} = 4'b1011; #10;
    {h,g,f,e} = 4'b1100; #10;
    {h,g,f,e} = 4'b1101; #10;
end

endmodule