module mled_datapath #
(
    parameter int CLOCK_F = 200_000_000
) (
    input [4:0] new_pos,
    output [23:0] leds,
    mled_interface.dp bus
);

wire clk = bus.clk;
wire rst = bus.rst;

localparam int DIVIDER_F = CLOCK_F / 24;
localparam int MAX_DIVF = DIVIDER_F * 8;
localparam int DIV_WIDTH = $clog2(MAX_DIVF);

wire [7:0] [DIV_WIDTH-1:0] DIV_SPD;
wire [7:0] [DIV_WIDTH-1:0] SPD_DIV;
genvar i;
generate
    for (i = 0; i < 8; i++) begin: SPD_ASSIGN
        assign DIV_SPD[i] = DIV_WIDTH'((i + 1) * DIVIDER_F);
        assign SPD_DIV[7-i] = DIV_WIDTH'((i + 1) * DIVIDER_F);
    end
endgenerate

logic [23:0] leds_reg;
always_ff @(posedge clk)
    if (rst)
        leds_reg <= 24'b1;
    else if (bus.move_en)
        leds_reg <= {leds_reg[22:0], leds_reg[23]};

logic [4:0] new_pos_reg, old_pos_reg;
logic [5:0] omn_reg;
logic [6:0] shift_upper_limit;
logic [1:0] pos_sync;
always_ff @(posedge clk)
    if (rst) begin
        new_pos_reg <= '0;
        old_pos_reg <= '0;
        omn_reg <= '0;
        shift_upper_limit <= '0;
        pos_sync <= '0;
    end else begin
        pos_sync <= {pos_sync[0], bus.load_en};
        if (bus.load_en) begin
            old_pos_reg <= new_pos_reg;
            new_pos_reg <= new_pos;
        end else if (pos_sync[0]) begin
            omn_reg <= old_pos_reg - new_pos_reg;
        end else if (pos_sync[1]) begin
            shift_upper_limit <= (omn_reg[5]) ? (7'd80 + {2'b0, ~omn_reg[4:0]}) : (7'd103 - {2'b0, omn_reg[4:0]});
        end
    end

logic [DIV_WIDTH:0] divc_la;
logic [DIV_WIDTH-1:0] divider_counter;
logic [6:0] shift_counter;
logic [1:0] divider_sync;
always_ff @(posedge clk) begin
    if (rst) begin
        divc_la <= '0;
        divider_counter <= '0;
        shift_counter <= '0;
        divider_sync <= '0;
    end else begin
        if (bus.ei_en) begin
            divc_la <= '0;
            divider_counter <= DIV_SPD[7];
            shift_counter <= 7'd7;
            divider_sync <= 2'b01;
        end else if (bus.run_en) begin
            divc_la <= '0;
            divider_counter <= DIVIDER_F[DIV_WIDTH-1:0];
            shift_counter <= shift_upper_limit;
            divider_sync <= 2'b00;
        end else if (bus.eo_en) begin
            divc_la <= '0;
            divider_counter <= SPD_DIV[7];
            shift_counter <= 7'd7;
            divider_sync <= 2'b10;
        end else if (bus.done_st) begin
            divider_sync <= 2'b00;
        end else begin
            divc_la <= divider_counter - 2'b10;
            divider_counter <= divider_counter - 1'b1;
            if (divc_la[DIV_WIDTH-1]) begin
                shift_counter <= shift_counter - 1'b1;
                if (divider_sync[0])
                    divider_counter <= DIV_SPD[shift_counter[2:0]];
                else if (divider_sync[1])
                    divider_counter <= SPD_DIV[shift_counter[2:0]];
                else
                    divider_counter <= DIVIDER_F[DIV_WIDTH-1:0];
            end
        end
    end
end

assign bus.dc_zero = divc_la[DIV_WIDTH-1];
assign bus.sc_zero = shift_counter == '0;
assign leds = leds_reg;

endmodule