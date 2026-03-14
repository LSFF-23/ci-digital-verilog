module tb_mdc;
reg clk, rst_n, start;
reg [7:0] A, B;
wire [7:0] out;
wire done;

initial begin
    clk = 0;
    forever #5 clk = !clk;
end

mdc dut (clk, rst_n, start, A, B, out, done);

initial begin
    start = 0;
    rst_n = 1; #10
    rst_n = 0; #10
    rst_n = 1; #30

    A = 8'd20; B = 8'd30; #10
    start = 1; #10
    start = 0; #130

    A = 8'd51; B = 8'd27; #10
    start = 1; #10
    start = 0; #130
    $stop(0);
end

endmodule