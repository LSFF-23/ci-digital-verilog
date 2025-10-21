// assign d = h & g;
module d_module (
    input h, g, f, e,
    output d
);

and A1(d, h, g);

endmodule

// assign c = (!h & g & e) | (h & !g);
module c_module (
    input h, g, f, e,
    output c
);

wire h_, g_, w1, w2;

not N1(g_, g);
not N2(h_, h);
and A1(w1, h_, g, e);
and A2(w2, h, g_);
or O1(c, w1, w2);

endmodule

// assign b = (!h & g & !e) | (!g & f) | (h & !g);
module b_module (
    input h, g, f, e,
    output b
);

wire h_, g_, e_, w1, w2, w3;

not N1(g_, g);
not N2(h_, h);
not N3(e_, e);
and A1(w1, h_, g, e_);
and A2(w2, g_, f);
and A3(w3, h, g_);
or O1(b, w1, w2, w3);

endmodule

// assign a = (!h & !g & !f & e) | (!h & g & !e) | (g & f) | (h & g & e) | (h & f);
module a_module (
    input h, g, f, e,
    output a
);

wire h_, g_, f_, e_, w1, w2, w3, w4, w5;

not N1(h_, h);
not N2(g_, g);
not N3(f_, f);
not N4(e_, e);
and A1(w1, h_, g_, e, f_);
and A2(w2, h_, g, e_);
and A3(w3, g, f);
and A4(w4, h, g, e);
and A5(w5, h, f);
or O1(a, w1, w2, w3, w4, w5);

endmodule

module hgfe2dcba (
    input h, g, f, e,
    output d, c, b, a
);

d_module D(h, g, f, e, d);
c_module C(h, g, f, e, c);
b_module B(h, g, f, e, b);
a_module A(h, g, f, e, a);

endmodule

module hgfe2dcba_tb;
reg h, g, f, e;
wire d, c, b, a;

hgfe2dcba dut (h, g, f, e, d, c, b, a);

initial begin
    $display("HGFE | DCBA");
    $monitor("%b%b%b%b | %b%b%b%b", h, g, f, e, d, c, b, a);
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