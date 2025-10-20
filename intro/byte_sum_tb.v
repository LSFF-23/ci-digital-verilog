`timescale 1ns/1ps

module byte_sum_tb;
    reg [7:0] a;
    reg [7:0] b;
    reg cin;
    wire [7:0] sum;
    wire cout;
    
    byte_sum dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));
    
    initial
    begin
        $monitor("t=%0d | a=%0d b=%0d cin=%b | sum=%0d cout=%b", $time, a, b, cin, sum, cout);
        a=8'd10;b=8'd32;cin=0;#5;
        a=8'd64;b=8'd64;#5;
        a=8'd255;b=8'd1;#5;
        $finish;
    end
endmodule