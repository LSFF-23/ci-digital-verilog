module sync_adder (clk, a, b, cin, c, cout);
    input [7:0] a, b;
    input cin, clk;
    output reg [7:0] c;
    output reg cout;

    always @(posedge clk) {cout, c} = a + b + cin;
endmodule

module sync_adder_tb;
    reg [7:0] a, b;
    reg cin, clk;
    wire [7:0] c;
    wire cout;

    always #5 clk = !clk;

    sync_adder dut (clk, a, b, cin, c, cout);

    initial begin
        $display("time | cin |    a     |    b     | cout |    c    ");
        $monitor("%4d | %3b | %b | %b | %4b | %b", $time, cin, a, b, cout, c);
        clk = 0; a = 0; b = 0; cin = 0;
        #5 a = 32; b = 64;
        #10 a = 64; b = 128;
        #10 a = 192; b = 63;
        #10 cin = 1;
        #10 a = 15; b = 31; cin = 0;
        #10 a = 200; b = 106;
        #10 $finish(0);
    end
endmodule