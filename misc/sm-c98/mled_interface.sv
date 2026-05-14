interface mled_interface;
logic capt_en;
logic move_en;
logic prep_en;

modport fsm (
    output  capt_en,
            move_en,
            prep_en
);

modport dp (
    input   capt_en,
            move_en
            prep_en
);

endinterface