module mled_tb;
logic clk;
logic rst;
logic start;
logic [4:0] new_pos;
logic [23:0] leds;
logic done;

mled_top#(1_000) dut (
    clk,
    rst,
    start,
    new_pos,
    leds,
    done
);

initial clk = 0;
always #5 clk = !clk;

integer seed, i;
initial begin
    rst = 1; start = 0; new_pos = 5'd0; seed = 42;
    @(posedge clk);
    rst = 0;
    @(posedge clk);
    
    repeat (10) begin
        new_pos = $random(seed);
        start = 1;
        @(posedge clk);
        start = 0;
        @(posedge clk);
        for (i = 2; !done; i++) @(posedge clk);
        $display("Pos = %d, Cycles = %d, LEDs = %h, Expected = %h", new_pos, i, leds, 24'b1 << new_pos);
        repeat (3) @(posedge clk);
    end

    $stop(0);
end

endmodule