module adder1digit (a, b, cin, s, cout);
input [3:0] a, b;
input cin;
output reg [3:0] s;
output reg cout;
reg [4:0] partial_sum;

always @* begin
    partial_sum = a + b + cin;
    if (partial_sum > 9) partial_sum = partial_sum + 6;
    s = partial_sum[3:0];
    cout = partial_sum[4];
end

endmodule

module adder1digit_tb;
    reg [3:0] a, b;
    reg cin;
    wire [3:0] s1, s2;
    wire cout1, cout2;

    adder1digit dut1 (a, b, cin, s1, cout1);

    initial begin
        $display("cin | a | b | cout1 | sum1 | cout2 | sum2 ");
        $monitor("%3b | %0d | %0d | %5b | %b | %5b | %b", cin, a, b, cout1, s1, cout2, s2);
        a = 1; b = 2; cin = 0;
        #1 a = 3; b = 4; cin = 1;
        #1 a = 4; b = 5; cin = 0;
        #1 a = 6; b = 7; cin = 0;
        #1 a = 9; b = 9; cin = 1;
    end
endmodule