module arbiter3x3 (clk, rst_n, request, grant);
input clk, rst_n;
input [1:3] request;
output [1:3] grant;

localparam IDLE = 2'b00;
localparam GRANT1 = 2'b01;
localparam GRANT2 = 2'b10;
localparam GRANT3 = 2'b11;
reg [1:0] state, next_state;

assign grant[1] = state == GRANT1;
assign grant[2] = state == GRANT2;
assign grant[3] = state == GRANT3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= next_state;
end

always @* begin
    next_state = state;
    case (state)
        IDLE: begin
            casex (request)
                3'b1xx: next_state = GRANT1;
                3'b01x: next_state = GRANT2;
                3'b001: next_state = GRANT3;
                default: next_state = IDLE;
            endcase
        end
        GRANT1: next_state = (request[1]) ? GRANT1 : IDLE;
        GRANT2: next_state = (request[2]) ? GRANT2 : IDLE;
        GRANT3: next_state = (request[3]) ? GRANT3 : IDLE;
        default: next_state = IDLE;
    endcase
end

endmodule