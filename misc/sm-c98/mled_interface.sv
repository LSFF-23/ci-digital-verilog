interface mled_interface (
    input clk,
    input rst
);

logic load_en;
logic move_en;
logic ei_en;
logic run_en;
logic eo_en;
logic done_st;

logic dc_zero;
logic sc_zero;

modport fsm (
    input   clk,
            rst,
    output  load_en,
            move_en,
            ei_en,
            run_en,
            eo_en,
            done_st,
    input   dc_zero,
            sc_zero
);

modport dp (
    input   clk,
            rst,
    input   load_en,
            move_en,
            ei_en,
            run_en,
            eo_en,
            done_st,
    output  dc_zero,
            sc_zero
);

endinterface