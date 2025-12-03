module fourone (clk, rst, in, out);
localparam ZERO = 0;
localparam FIRST = 1;
localparam SECOND = 2;
localparam THRID = 3;
localparam FOURTH = 4;

input clk, rst, in;
output reg out;

reg [2:0] state, next_state;

always @(posedge clk or posedge rst)
    if (rst)
        state = ZERO;
    else
        state = next_state;

always @*
    case (state)
        ZERO: next_state = in ? FIRST : ZERO;
        FIRST: next_state = in ? SECOND : ZERO;
        SECOND: next_state = in ? THIRD : ZERO;
        THIRD: next_state = in ? FOURTH : ZERO;
        FOURTH: next_state = in ? FOURTH : ZERO;
        default: next_state = ZERO;
    endcase

always @*
    case (state)
        ZERO, FIRST, SECOND, THIRD: out = 0;
        FOURTH: out = 1;
        default: out = 0;
    endcase

endmodule