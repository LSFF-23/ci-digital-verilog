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
localparam int DIV_SPD5 = 5 * DIV_BASE;
localparam int DIV_SPD6 = 6 * DIV_BASE;
localparam int DIV_SPD7 = 7 * DIV_BASE;
localparam int DIV_SPD8 = 8 * DIV_BASE;
localparam int DIV_WIDTH = $clog2(DIV_SPD8);

logic [DIV_WIDTH-1:0] divider_counter;
logic [6:0] divider_cycles;
logic [DIV_WIDTH-1:0] divider_limit;
logic driving;

logic [23:0] leds_reg;
assign leds = leds_reg;

logic [4:0] cur_pos, captured_pos;

// fixing critical path (1)
wire [4:0] incp1_comb = 5'd24 - (cur_pos - captured_pos);
wire [4:0] incp2_comb = captured_pos - cur_pos;
logic [4:0] inc_p1, inc_p2, inc_cond, inc_pos, start_reg1, start_reg2, start_reg3;
wire cond_comb = cur_pos > captured_pos;
always_ff @(posedge clk)
    if (rst) begin
        captured_pos <= '0;
        cur_pos <= '0;
        start_reg1 <= '0;

        inc_p1 <= '0;
        inc_p2 <= '0;
        inc_cond <= '0;
        start_reg2 <= '0;

        inc_pos <= '0;
        start_reg3 <= '0;
    end else if (start) begin
        cur_pos <= captured_pos;
        captured_pos <= new_pos;
        start_reg1 <= '1;
    end else if (start_reg1) begin
        start_reg1 <= '0;
        inc_p1 <= incp1_comb;
        inc_p2 <= incp2_comb;
        inc_cond <= cond_comb;
        start_reg2 <= '1;
    end else if (start_reg2) begin
        start_reg2 <= '0;
        inc_pos <= inc_cond ? inc_p1 : inc_p2;
        start_reg3 <= '1;
    end else
        start_reg3 <= '0;

// visual speed-up/slowdown effect
wire [6:0] final_cycle = 7'(96 +  inc_pos);
always_comb
    if (divider_cycles == 7'd0 || divider_cycles == final_cycle - 2)
        divider_limit = DIV_SPD8[DIV_WIDTH-1:0];
    else if (divider_cycles == 7'd1 || divider_cycles == final_cycle - 3)
        divider_limit = DIV_SPD7[DIV_WIDTH-1:0];
    else if (divider_cycles == 7'd2 || divider_cycles == final_cycle - 4)
        divider_limit = DIV_SPD6[DIV_WIDTH-1:0];
    else if (divider_cycles == 7'd3 || divider_cycles == final_cycle - 5)
        divider_limit = DIV_SPD5[DIV_WIDTH-1:0];
    else if (divider_cycles == 7'd4 || divider_cycles == final_cycle - 6)
        divider_limit = DIV_SPD4[DIV_WIDTH-1:0];
    else if (divider_cycles == 7'd5 || divider_cycles == final_cycle - 7)
        divider_limit = DIV_SPD3[DIV_WIDTH-1:0];
    else if (divider_cycles == 7'd6 || divider_cycles == final_cycle - 8)
        divider_limit = DIV_SPD2[DIV_WIDTH-1:0];
    else
        divider_limit = DIV_BASE[DIV_WIDTH-1:0];

// fixing critical path (2)
wire divider_comb = divider_counter == divider_limit - 1;
wire cycles_comb = divider_cycles == final_cycle - 1;
logic divider_tick, cycles_tick;
always_ff @(posedge clk)
    if (rst) begin
        divider_tick <= '0;
        cycles_tick <= '0;
    end else begin
        divider_tick <= divider_comb;
        cycles_tick <= cycles_comb;
    end

// state machine: driving/idle
always_ff @(posedge clk)
    if (rst) begin
        divider_counter <= '0;
        divider_cycles <= '0;
        driving <= '0;
    end else if (driving)
        if (divider_tick) begin
            divider_counter <= '0;
            if (cycles_tick)
                driving <= '0;
            else
                divider_cycles <= divider_cycles + 1'b1;
        end else
            divider_counter <= divider_counter + 1'b1;
    else
        if (start_reg3) begin
            divider_counter <= '0;
            divider_cycles <= '0;
            driving <= '1;
        end

// circular shift-register
wire move = driving && divider_tick;
always_ff @(posedge clk)
    if (rst)
        leds_reg <= 24'd1;
    else if (move) begin
        leds_reg <= {leds_reg[22:0], leds_reg[23]};
    end

endmodule