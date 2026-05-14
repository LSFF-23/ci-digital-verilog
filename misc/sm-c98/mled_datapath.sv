module mled_datapath (
    input clk,
    input rst,
    input [4:0] new_pos,
    output [23:0] leds,
    mled_interface.dp bus
);

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
    end else if (bus.capt_en) begin
        old_pos_reg <= new_pos_reg;
        new_pos_reg <= new_pos;
    end

logic [6:0] shift_counter;
logic [1:0] pos_sync;
wire old_gt_new = old_pos_reg > new_pos_reg;
wire [6:0] old_minus_new = old_pos_reg - new_pos_reg;
wire [6:0] new_minus_old = new_pos_reg - old_pos_reg;
always_ff @(posedge clk)
    if (rst) begin
        shift_counter <= '0;
        pos_sync <= '0;
    end else begin
        pos_sync <= {pos_sync[0], bus.prep_en};
    end

endmodule