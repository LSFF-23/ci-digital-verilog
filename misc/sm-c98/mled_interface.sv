interface mled_interface;
logic load_en;
logic move_en;
logic ei_en;
logic eo_en;

logic dc_zero;
logic ei_zero;
logic eo_zero;
logic sc_zero;

modport fsm (
    output  load_en,
            move_en,
            ei_en,
            eo_en,
            sc_ld,
    input   dc_zero,
            ei_zero,
            eo_zero
            sc_zero
);

modport dp (
    input   load_en,
            move_en,
            ei_en,
            eo_en,
            sc_ld,
    output  dc_zero,
            ei_zero,
            eo_zero,
            sc_zero
);

endinterface