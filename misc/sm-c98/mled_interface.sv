interface mled_interface;
logic load_in;
logic move_en;
logic prep_en;
logic prep_rdy;
logic counter_ld;

modport fsm (
    input   prep_rdy,
    output  load_in,
            move_en,
            prep_en,
            counter_ld
);

modport dp (
    output  prep_rdy,
    input   load_in,
            move_en,
            prep_en,
            counter_ld
);

endinterface