module adder1digit (a, b, cin, s, cout);
input [3:0] a, b;
input cin;
output [3:0] s;
output cout;
wire [4:0] partial_sum1, partial_sum2;

assign partial_sum1 = a + b + cin;
assign partial_sum2 = (partial_sum1 > 9)?(partial_sum1 + 6):(partial_sum1);
assign s = partial_sum2[3:0];
assign cout = partial_sum2[4];

endmodule

module adder1digit_tb;
    reg [3:0] a, b;
    reg cin;
    wire [3:0] s;
    wire cout;

    adder1digit dut1 (a, b, cin, s, cout);

    initial begin
        $display("cin | a | b | cout |  s ");
        $monitor("%3b | %0d | %0d | %4b | %4b", cin, a, b, cout, s);
        a = 1; b = 2; cin = 0;
        #1 a = 3; b = 4; cin = 1;
        #1 a = 4; b = 5; cin = 0;
        #1 a = 6; b = 7; cin = 0;
        #1 a = 9; b = 9; cin = 1;
    end
endmodule