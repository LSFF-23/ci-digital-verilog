module latch_rs (r, s, qa, qb);
input r, s;
output qa, qb;

assign qa = ~(r | qb);
assign qb = ~(s | qa);

endmodule
// teste
module latch_tb;
reg r, s;
wire qa, qb;

latch_rs dut (r, s, qa, qb);

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