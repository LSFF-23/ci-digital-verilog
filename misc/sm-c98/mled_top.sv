module mled_top #
(
    parameter int CLOCK_F = 200_000_000
) (
    input clk,
    input rst,
    input start,
    input [4:0] new_pos,
    output [23:0] leds,
    output done
);

mled_interface i_mled(.clk(clk), .rst(rst));

mled_fsm u_mled_fsm (
    .start(start),
    .done(done),
    .bus(i_mled.fsm)
);

mled_datapath #(CLOCK_F) u_mled_dp (
    .new_pos(new_pos),
    .leds(leds),
    .bus(i_mled.dp)
);

endmodule