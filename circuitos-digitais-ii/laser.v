module laser (clk, rst, btn, led);
input clk, rst, btn;
output reg led;

localparam OFF = 0;
localparam LIG1 = 1;
localparam LIG2 = 2;
localparam LIG3 = 3;

reg [1:0] state, next_state;

always @(posedge clk or posedge rst) begin
    if (rst)
        state <= OFF;
    else
        state <= next_state;
end

always @* begin
    case (state)
        OFF: led = 0;
        LIG1, LIG2, LIG3: led = 1;
        default: led = 0;
    endcase
end

always @* begin
    case (state)
        OFF: next_state = btn ? LIG1 : OFF;
        LIG1: next_state = btn ? LIG1 : LIG2;
        LIG2: next_state = btn ? LIG1 : LIG3;
        LIG3: next_state = btn ? LIG1 : OFF;
        default: next_state = OFF;
    endcase
end

endmodule