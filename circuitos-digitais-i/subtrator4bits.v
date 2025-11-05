module adder #(parameter N = 2) (a, b, cin, sum, cout);
    input [N-1:0] a, b;
    input cin;
    output [N-1:0] sum;
    output cout;

    assign {cout, sum} = a + b + cin;
endmodule

module subtrator4bits (a, b, diff, bout);
    input [3:0] a, b;
    output [3:0] diff;
    output bout;

    adder#(4) a1 (a, ~b, 1'b1, diff, bout);
endmodule

module subtrator4bits_tb;
reg [3:0] a, b;
reg bin;
wire [3:0] diff;
wire bout;

subtrator4bits dut (a, b, diff, bout);

initial begin
    $display("  a   |   b  | borrow |   d   ");
    $monitor(" %b | %b | %6b | %b", a, b, bout, diff);
    a = 5; b = 2;
    #1 a = 2; b = 5;
    #1 a = 3; b = 3;
    #1 a = 0; b = 7;
    #1 $finish(0);
end

endmodule