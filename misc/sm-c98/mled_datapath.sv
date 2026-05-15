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

wire [DIV_WIDTH-1:0] [7:0] DIV_SPD;
wire [DIV_WIDTH-1:0] [7:0] SPD_DIV;
genvar i;
generate
    for (i = 0; i < 8; i++) begin: SPD_ASSIGN
        assign DIV_SPD[i] = (i + 1) * DIVIDER_F;
        assign SPD_DIV[7-i] = (i + 1) * DIVIDER_F;
    end
endgenerate

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
    end else if (bus.load_en) begin
        old_pos_reg <= new_pos_reg;
        new_pos_reg <= new_pos;
    end

logic [6:0] shift_upper_limit;
logic [5:0] omn_reg;
always_ff @(posedge clk)
    if (rst) begin
        shift_upper_limit <= '0;
        omn_reg <= '0;
    end else begin
        omn_reg <= old_pos_reg - new_pos_reg;
        shift_upper_limit <= (omn_reg[5]) ? ('d97 + ~omn_reg[4:0]) : ('d120 - omn_reg[4:0]);
    end

logic [DIV_WIDTH-1:0] divider_counter;
logic [6:0] shift_counter;
logic [2:0] ei_counter, eo_counter;
always_ff @(posedge clk) begin
    if (rst) begin
        divider_counter <= '0;
        shift_counter <= '0;
        ei_counter <= '0;
        eo_counter <= '0;
    end else begin
        if (bus.load_en) begin
            ei_counter <= '1;
            eo_counter <= '1;
        end else if (bus.ei_en) begin
            ei_counter <= ei_counter - 1'b1;
            divider_counter <= DIV_SPD[ei_counter];
        end else if (bus.sc_ld) begin
            shift_counter <= shift_upper_limit;
            divider_counter <= DIVIDER_F;
        end else if (bus.run_en) begin
            divider_counter <= DIVIDER_F;
        end else if (bus.eo_en) begin
            eo_counter <= eo_counter - 1'b1;
            divider_counter <= SPD_DIV[eo_counter];
        end else begin
            divider_counter <= divider_counter - 1'b1;
        end
    end
end

assign dc_zero = divider_counter == '0;
assign ei_zero = ei_counter == '0;
assign eo_zero = eo_counter == '0;
assign sc_zero = shift_counter == '0;

endmodule