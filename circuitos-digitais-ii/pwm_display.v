module pwm_display (clk, rst, btn, pwm_out, btn_cnt);
localparam MAX_VALUE = 2_000_000;
input clk, rst, btn;
output reg pwm_out;
output reg [3:0] btn_cnt;

reg [20:0] cnt;
reg [20:0] duty_cnt;

always @(posedge clk) begin
    if (rst)
        cnt <= 0;
    else if (cnt == MAX_VALUE - 1)
        cnt <= 0;
    else
        cnt <= cnt + 1;
end

always @(posedge rst or posedge btn) begin
    if (rst)
        btn_cnt <= 0;
    else if (btn)
        btn_cnt <= btn_cnt < 9 ? btn_cnt + 1 : 0;
end

always @* begin
    duty_cnt = (btn_cnt >= 1 && btn_cnt <= 9) ? (MAX_VALUE * btn_cnt) / 10 : 0;
end

always @(posedge clk) begin
    if (rst)
        pwm_out <= 0;
    else
        pwm_out <= (cnt < duty_cnt);
end

endmodule

module pwm_display_tb;
localparam MAX_VALUE = 2_000_000;
reg clk, rst, btn;
wire pwm_out;
wire [3:0] btn_cnt;
integer i;
    
pwm_display dut (clk, rst, btn, pwm_out, btn_cnt);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 0; btn = 0;
    #25 rst = 1;
    #25 rst = 0;
    #(MAX_VALUE);
    for (i = 1; i <= 10; i = i + 1) begin
        #25 btn = 1;
        #25 btn = 0;
        #(MAX_VALUE);
    end
    $finish(0);
end

endmodule
