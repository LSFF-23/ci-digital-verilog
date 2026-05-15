module mled_fsm (
    input clk,
    input rst,
    input start,
    output done,
    mled_interface.fsm bus
);

enum logic [3:0] {
    IDLE = 4'b0000,
    CAPTURE = 4'b0001,
    EI_KICK = 4'b0010,
    EASE_IN = 4'b1000,
    LOAD_SC = 4'b0011,
    RUN_KICK = 4'b0100,
    RUN_MODE = 4'b1001,
    EO_KICK = 4'b0101,
    EASE_OUT = 4'b1010,
    DONE = 4'b0110
} state, next_state;

always_ff @(posedge clk)
    if (rst)
        state <= IDLE;
    else
        state <= next_state;

always_comb begin
    next_state = state;
    case (state)
        IDLE: if (start) next_state = CAPTURE;
        CAPTURE: next_state = EI_KICK;
        EI_KICK: next_state = EASE_IN;
        EASE_IN: if (bus.dc_zero && bus.ei_zero) next_state = LOAC_SC;
                 else if (bus.dc_zero && !bus.ei_zero) next_state = EI_KICK;
        LOAC_SC: next_state = RUN_MODE;
        RUN_KICK: next_state = RUN_MODE;
        RUN_MODE: if (bus.dc_zero && bus.sc_zero) next_state = EO_KICK;
        EO_KICK: next_state = EASE_OUT;
        EASE_OUT: if (bus.dc_zero && bus.eo_zero) next_state = DONE;
                  else if (bus.dc_zero && !bus.eo_zero) next_state = EO_KICK;
    endcase
end

assign bus.load_en = state == CAPTURE;
assign bus.move_en = bus.dc_zero && state[3];
assign bus.ei_en = state == EI_KICK;
assign bus.eo_en = state == EO_KICK;
assign bus.sc_ld = state == LOAC_SC;
assign bus.run_en = state == RUN_KICK;

endmodule