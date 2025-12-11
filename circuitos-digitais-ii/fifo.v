module fifo (clk, reset, w_data, wr, rd, r_data, empty, full);
input clk, reset, wr, rd;
input [7:0] w_data;
output reg [7:0] r_data;
output reg empty, full;

reg [7:0] register_file[0:7];
reg [2:0] wp, rp;
integer i;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        wp <= 0; rp <= 0; empty <= 1; full <= 0;
        for (i = 0; i < 8; i = i + 1) register_file[i] <= 0;
    end else begin
        if (rd && !empty) begin
            r_data <= register_file[rp];
            rp <= (rp + 1) % 8;
            full <= 0;
            empty <= ((rp + 1) % 8 == wp);
        end
        if (wr && !full) begin
            register_file[wp] <= w_data;
            wp <= (wp + 1) % 8;
            full <= ((wp + 1) % 8 == rp);
            empty <= 0;
        end
    end
end

endmodule

module fifo_tb;
reg rd;
reg wr;
reg [7:0] sw;
reg clk;
reg reset;
wire [7:0] led;
wire full;
wire empty;

fifo UUT (
    .clk(clk), 
    .reset(reset), 
    .rd(rd), 
    .wr(wr), 
    .w_data(sw), 
    .full(full), 
    .empty(empty), 
    .r_data(led)
);

always #5 clk = !clk;

initial begin
    $display($time, " << Starting the Simulation >>");
    clk = 0; wr = 1'b0; rd = 1'b0; sw = 8'd0; reset=1'b0;
    // reset 
    reset=1'b0; #10; reset=1'b1; #10; reset=1'b0; #10;
    // Exibindo cabecalho no console
    $display("Tempo\twr\trd\tsw\tled");
    $monitor("%0t\t%b\t%b\t%d\t%d", $time, wr, rd, sw, led);
    wr = 1'b0; rd = 1'b0; sw = 8'd0; reset=1'b0;
    // Realiza 8+2 escritas para testar condicao full
    wr = 1'b1; sw = 8'd1; #10;
    wr = 1'b1; sw = 8'd2; #10;
    wr = 1'b1; sw = 8'd3; #10;
    wr = 1'b1; sw = 8'd4; #10;
    wr = 1'b1; sw = 8'd5; #10; wr = 1'b0; #10;
    wr = 1'b1; sw = 8'd6; #10; wr = 1'b0; #10;
    wr = 1'b1; sw = 8'd7; #10; wr = 1'b0; #10;
    wr = 1'b1; sw = 8'd8; #10; wr = 1'b0; #10;
    wr = 1'b1; sw = 8'd9; #10; 
    wr = 1'b1; sw = 8'd10; #10; wr = 1'b0;
    // Realiza 8+2 leituras para testar condicao full
    rd = 1'b1; #10; rd = 1'b0; #10;
    rd = 1'b1; #10; rd = 1'b0; #10;
    rd = 1'b1; #10; rd = 1'b0; #10;
    rd = 1'b1; #10; rd = 1'b0; #10;
    rd = 1'b1; #10; rd = 1'b0; #10;
    rd = 1'b1; #10; rd = 1'b0; #10;
    rd = 1'b1; #10; rd = 1'b0; #10;
    rd = 1'b1; #10; rd = 1'b0; #10;
    rd = 1'b1; #10; rd = 1'b0; #10;
    rd = 1'b1; #10; rd = 1'b0; #10;
    // Finaliza a simulacao
    $finish(0);
end
endmodule