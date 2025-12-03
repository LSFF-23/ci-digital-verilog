module pwm (
    input  wire        clk,
    input  wire        rst,
    input  wire [1:0]  duty,
    output reg         pwm_out
);

    reg [20:0] cnt;
    reg [20:0] duty_cnt;

    always @(posedge clk) begin
        if (rst)
            cnt <= 21'd0;
        else if (cnt == 21'd1_999_999)
            cnt <= 21'd0;
        else
            cnt <= cnt + 21'd1;
    end

    always @* begin
        case (duty)
            2'b00: duty_cnt = 21'd0_500_000;
            2'b01: duty_cnt = 21'd1_000_000;
            2'b10: duty_cnt = 21'd1_500_000;
            2'b11: duty_cnt = 21'd2_000_000;
            default: duty_cnt = 21'd0_000_000;
        endcase
    end

    always @(posedge clk) begin
        if (rst)
            pwm_out <= 1'b0;
        else
            pwm_out <= (cnt < duty_cnt);
    end

endmodule

module pwm_tb;
    reg        clk;
    reg        rst;
    reg  [1:0] duty;
    wire       pwm_out;
    
    pwm dut (clk, rst, duty, pwm_out);

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst   = 1'b1;
        duty = 2'b00;
        #50;
        rst   = 1'b0;
        #(40_000_000);
        duty = 2'b01;
        #(40_000_000);
        duty = 2'b10;
        #(40_000_000);
        duty = 2'b11;
        #(40_000_000);
        $finish(0);
    end

endmodule
