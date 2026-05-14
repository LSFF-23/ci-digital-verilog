module mled_datapath (
    input clk,
    input rst,
    input [4:0] new_pos,
    output [23:0] leds,
    mled_interface.dp bus
);

localparam int CLOCK_F = 50_000_000;
localparam int DIVIDER_F = CLOCK_F / 24;
localparam int MAX_DIVF = DIVIDER_F * 8;
localparam int DIV_WIDTH = $clog2(MAX_DIVF);

logic [23:0] leds_reg;
always_ff @(posedge clk)
    if (rst)
        leds_reg <= 24'b1;
    else if (bus.move_en)
        leds_reg <= {leds[22:0], leds[23]};

logic [4:0] new_pos_reg, old_pos_reg;
always_ff @(posedge clk)
    if (rst) begin
        new_pos_reg <= '0;
        old_pos_reg <= '0;
    end else if (bus.load_in) begin
        old_pos_reg <= new_pos_reg;
        new_pos_reg <= new_pos;
    end

logic [6:0] shift_upper_limit;
logic [2:0] pos_sync;
wire [6:0] old_minus_new = old_pos_reg - new_pos_reg;
wire [6:0] new_minus_old = new_pos_reg - old_pos_reg;
wire old_gt_new = old_pos_reg > new_pos_reg;
always_ff @(posedge clk)
    if (rst) begin
        shift_upper_limit <= '0;
        pos_sync <= '0;
    end else begin
        pos_sync <= {pos_sync[1:0], bus.prep_en};
        if (pos_sync[0] && old_gt_new)
            shift_upper_limit <= 7'd120;
        else if (pos_sync[0] && !old_gt_new)
            shift_upper_limit <= 7'd96;
        else if (pos_sync[1] && old_gt_new)
            shift_upper_limit <= shift_upper_limit - old_minus_new;
        else if (pos_sync[1] && !old_gt_new)
            shift_upper_limit <= shift_upper_limit + new_minus_old;
    end

logic [DIV_WIDTH-1:0] divider_counter, divider_max;
logic [6:0] shift_counter;
logic [2:0] aux_counter;
always_ff @(posedge clk)
    if (rst) begin
        divider_counter <= '0;
        divider_max <= '0;
        shift_counter <= '0;
        aux_counter <= '0;
    end else begin
        
    end

assign bus.prep_rdy = pos_sync[2];

endmodule