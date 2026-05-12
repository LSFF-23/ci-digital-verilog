module mled_driver #
(
    parameter CLOCK_FREQ = 50_000_000
)
(
    input clk,
    input rst,
    input start,
    input [4:0] new_pos,
    output [23:0] leds
);

localparam int DIV_BASE = CLOCK_FREQ / 24;
localparam int DIV_SPD2 = 2 * DIV_BASE;
localparam int DIV_SPD3 = 3 * DIV_BASE;
localparam int DIV_SPD4 = 4 * DIV_BASE;
localparam int DIV_WIDTH = $clog2(DIV_SPD4);

logic [DIV_WIDTH-1:0] divider_counter;
logic [6:0] divider_cycles;
logic [DIV_WIDTH-1:0] divider_limit;
logic driving;
wire [6:0] final_pos = 7'(72 + new_pos);

always_comb
    if (divider_cycles == 7'd0 || divider_cycles == final_pos - 2)
        divider_limit = DIV_SPD4[DIV_WIDTH-1:0];
    else if (divider_cycles == 7'd1 || divider_cycles == final_pos - 3)
        divider_limit = DIV_SPD3[DIV_WIDTH-1:0];
    else if (divider_cycles == 7'd2 || divider_cycles == final_pos - 4)
        divider_limit = DIV_SPD2[DIV_WIDTH-1:0];
    else
        divider_limit = DIV_BASE[DIV_WIDTH-1:0];

always_ff @(posedge clk)
    if (rst) begin
        divider_counter <= '0;
        divider_cycles <= '0;
        driving <= '0;
    end else if (driving)
        if (divider_counter == divider_limit - 1) begin
            divider_counter <= '0;
            if (divider_cycles == final_pos - 1)
                driving <= '0;
            else
                divider_cycles <= divider_cycles + 1'b1;
        end else
            divider_counter <= divider_counter + 1'b1;
    else
        if (start) begin
            divider_counter <= '0;
            divider_cycles <= '0;
            driving <= '1;
        end

logic [23:0] leds_reg = 24'd1;
assign leds = leds_reg;
always_ff @(posedge clk)
    if (rst)
        leds_reg <= 24'd1;
    else if (move) begin
        leds_reg <= {leds_reg[22:0], leds_reg[23]};
    end

logic move;
always_ff @(posedge clk)
    if (rst)
        move <= '0;
    else if (driving && divider_counter == divider_limit - 1)
        move <= '1;
    else
        move <= '0;

endmodule