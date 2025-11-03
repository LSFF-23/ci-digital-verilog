module adder1digit_comportamental (a, b, cin, s, cout);
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

module adder1digit_comportamental_tb;
    reg [3:0] a, b;
    reg cin;
    wire [3:0] s;
    wire cout;

    adder1digit_comportamental dut (a, b, cin, s, cout);

    initial begin
        $display("cin | a | b | cout | sum ");
        $monitor("%3b | %0d | %0d | %4b | %b", cin, a, b, cout, s);
        a = 1; b = 2; cin = 0;
        #1 a = 3; b = 4; cin = 1;
        #1 a = 4; b = 5; cin = 0;
        #1 a = 6; b = 7; cin = 0;
        #1 a = 9; b = 9; cin = 1;
    end
endmodule