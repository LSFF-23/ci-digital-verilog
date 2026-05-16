module mled_tb;
logic clk;
logic rst;
logic start;
logic [4:0] new_pos;
logic [23:0] leds;
logic done;

localparam int CLOCK_F = 1200;
localparam int DIVIDER_F = CLOCK_F / 24;
localparam int MAX_DIVF = DIVIDER_F * 8;
localparam int MAX_CYCLES = 6 + 2*(8+7+6+5+4+3+2+1)*DIVIDER_F+104*DIVIDER_F;

mled_top#(.CLOCK_F(CLOCK_F)) dut (
    clk,
    rst,
    start,
    new_pos,
    leds,
    done
);

initial clk = 0;
always #5 clk = !clk;

integer seed, i, file;
initial begin
    file = $fopen("log.txt", "w");
    if (!file) begin 
        $display("Falha na gravação do arquivo: log.txt");
        $finish(0);
    end

    $display("Max Cycles Estimative: %d", MAX_CYCLES);
    $fdisplay(file, "Max Cycles Estimative: %d", MAX_CYCLES);

    rst = 1; start = 0; new_pos = 5'd0; seed = 11;
    @(posedge clk);
    rst = 0;
    @(posedge clk);
    
    repeat (10) begin
        new_pos = $random(seed) % 5'd24;
        start = 1;
        @(posedge clk);
        start = 0;
        @(posedge clk);
        for (i = 2; !done; i++) @(posedge clk);
        $display("Pos = %d, Cycles = %d, LEDs = %h, Expected = %h", new_pos, i, leds, 24'b1 << new_pos);
        $fdisplay(file, "Pos = %d, Cycles = %d, LEDs = %h, Expected = %h", new_pos, i, leds, 24'b1 << new_pos);
        repeat (3) @(posedge clk);
    end

    $fclose(file);
    $stop(0);
end

endmodule