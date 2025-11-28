module segments_decoder (
    input [3:0] dcba,
    output reg [6:0] segments 
);

always @ (*) begin
    case (dcba)
        4'b0000: segments = 7'b0000001;
        4'b0001: segments = 7'b1001111;
        4'b0010: segments = 7'b0010010;
        4'b0011: segments = 7'b0000110;
        4'b0100: segments = 7'b1001100;
        4'b0101: segments = 7'b0100100;
        4'b0110: segments = 7'b0100000;
        4'b0111: segments = 7'b0001111;
        4'b1000: segments = 7'b0000000;
        4'b1001: segments = 7'b0000100;
        4'b1010: segments = 7'b0001000; // A
        4'b1011: segments = 7'b1100000; // b
        4'b1100: segments = 7'b0110001; // C
        4'b1101: segments = 7'b1000010; // d
        4'b1110: segments = 7'b0110000; // E
        4'b1111: segments = 7'b0111000; // F
        default: segments = 7'b1111111;
    endcase
end

endmodule

module pwm (clk, rst, btn, pwm_out, btn_cnt);
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

module pwm_display (clk, rst, btn0, btn1, pwm_out0, pwm_out1, segments0, segments1);
input clk, rst, btn0, btn1;
output pwm_out0, pwm_out1;
output [6:0] segments0, segments1;

wire [3:0] btn_cnt0, btn_cnt1;

pwm instance0 (clk, rst, btn0, pwm_out0, btn_cnt0);
pwm instance1 (clk, rst, btn1, pwm_out1, btn_cnt1);
segments_decoder decoder0 (btn_cnt0, segments0);
segments_decoder decoder1 (btn_cnt1, segments1);

endmodule

module pwm_display_tb;
localparam MAX_VALUE = 2_000_000;
localparam PWM_CYCLE = MAX_VALUE * 10;
reg clk, rst, btn0, btn1;
wire pwm_out0, pwm_out1;
wire [6:0] segments0, segments1;
integer i;
    
pwm_display dut (clk, rst, btn0, btn1, pwm_out0, pwm_out1, segments0, segments1);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 0; btn0 = 0; btn1 = 0;
    #25 rst = 1;
    #25 rst = 0;
    #(PWM_CYCLE);
    #25 btn0 = 1;
    #25 btn0 = 0;
    #25 btn1 = 1;
    #25 btn1 = 0;
    #25 btn1 = 1;
    #25 btn1 = 0;
    #(PWM_CYCLE);
    #25 btn0 = 1;
    #25 btn0 = 0;
    #25 btn0 = 1;
    #25 btn0 = 0;
    #25 btn1 = 1;
    #25 btn1 = 0;
    #25 btn1 = 1;
    #25 btn1 = 0;
    #(PWM_CYCLE);
    $finish(0);
end

endmodule