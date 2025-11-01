module async_adder (a, b, cin, c, cout);
    input [7:0] a, b;
    input cin;
    output [7:0] c;
    output cout;

    assign {cout, c} = a + b + cin;
endmodule

module async_adder_tb;
    reg [7:0] a, b;
    reg cin;
    wire [7:0] c;
    wire cout;

    async_adder dut (a, b, cin, c, cout);

    initial begin
        $display("cin |    a     |    b     | cout |    c    ");
        $monitor("%3b | %b | %b | %4b | %b", cin, a, b, cout, c);
        a = 32; b = 64; cin = 0;
        #1 a = 64; b = 128;
        #1 a = 192; b = 63;
        #1 cin = 1;
        #1 a = 15; b = 31; cin = 0;
        #1 a = 200; b = 106;
    end
endmodule