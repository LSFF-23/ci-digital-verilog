module adder1digit_fdd (a, b, cin, s, cout);
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

module adder3digit_estrutural (a, b, cin, s, cout);
input [11:0] a, b;
input cin;
output [11:0] s;
output cout;

wire c2, c1;

adder1digit_fdd a1 (a[3:0], b[3:0], cin, s[3:0], c1);
adder1digit_fdd a2 (a[7:4], b[7:4], c1, s[7:4], c2);
adder1digit_fdd a3 (a[11:8], b[11:8], c2, s[11:8], cout);

endmodule

module adder3digit;
reg [11:0] a, b;
reg cin;
wire [11:0] s;
wire cout;

adder3digit_estrutural dut (a, b, cin, s, cout);

initial begin
    $display("       a       |        b       | cin | cout |       s     ");
    $monitor("%b_%b_%b | %b_%b_%b | %3b | %4b | %b_%b_%b", a[11:8], a[7:4], a[3:0], b[11:8], b[7:4], b[3:0], cin, cout, s[11:8], s[7:4], s[3:0]);
    a = 12'b0001_0000_0000; b = 12'b0010_0010_0101; cin = 0;
    #1 a = 12'b1001_1001_1001; b = 12'b1001_1001_1001; cin = 0;
    #1 cin = 1;
end

endmodule