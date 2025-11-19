module latch_sr (r, s, qa, qb);
input r, s;
output qa, qb;

nor (qa, r, qb);
nor (qb, s, qa);

endmodule

module latch_tb;
reg r, s;
wire qa, qb;

latch_sr dut (r, s, qa, qb);

initial begin
    $display("r s q Q");
    $monitor("%b %b %b %b", r, s, qa, qb);
    r = 0; s = 0;
    #1 s = 1;
    #1 s = 0;
    #1 r = 1;
    #1 r = 0;
    #1 r = 1; s = 1;
    #1 $finish(0);
end

endmodule