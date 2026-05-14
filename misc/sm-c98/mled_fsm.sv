module mled_fsm (
    input clk,
    input rst,
    input start,
    output done,
    mled_interface.fsm bus
);

enum logic [3:0] {
    IDLE,
    CAPTURE,
    PREPARATION,
    LOAD_COUNTER
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
        CAPTURE: next_state = PREPARATION;
        PREPARATION: if (bus.prep_rdy) next_state = LOAD_COUNTER;
    endcase
end

assign bus.capt_en = state == CAPTURE;
assign bus.load_in = state == PREPARATION;
assign bus.counter_ld = state == LOAD_COUNTER;

endmodule