module fifo_parametrized #(parameter WORD_SIZE = 8, MEM_SIZE = 8) (
    input        clk,
    input        reset,
    input        rd,
    input        wr,
    input  [WORD_SIZE-1:0] w_data,
    output       full,
    output       empty,
    output [WORD_SIZE-1:0] r_data
);
    localparam ADDR_SIZE = $clog2(MEM_SIZE);
    integer i;

    // Internal memory array
    reg [WORD_SIZE:0] array_reg [0:MEM_SIZE-1];

    // Read/write pointer registers
    reg  [ADDR_SIZE-1:0] w_ptr_reg, w_ptr_next;
    reg  [ADDR_SIZE-1:0] r_ptr_reg, r_ptr_next;
    wire [ADDR_SIZE-1:0] w_ptr_succ, r_ptr_succ;

    reg  full_reg,  empty_reg;
    reg  full_next, empty_next;

    // Concatenated write/read operation
    wire [1:0] wr_op;

    // Write enable: enable writing when FIFO is not full
    wire wr_en;
    assign wr_en = wr & ~full_reg;

    // Writing to FIFO buffer
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < MEM_SIZE; i = i + 1)
                array_reg[i] <= 0;
        end else if (wr_en) begin
            array_reg[w_ptr_reg] <= w_data;
        end
    end

    // Reading from FIFO buffer
    assign r_data = array_reg[r_ptr_reg];

    // Register read and write pointers
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            w_ptr_reg <= 0;
            r_ptr_reg <= 0;
            full_reg  <= 0;
            empty_reg <= 1;
        end else begin
            w_ptr_reg <= w_ptr_next;
            r_ptr_reg <= r_ptr_next;
            full_reg  <= full_next;
            empty_reg <= empty_next;
        end
    end

    // Pointer increment logic
    assign w_ptr_succ = w_ptr_reg + 1;
    assign r_ptr_succ = r_ptr_reg + 1;

    // Concatenating write and read operations
    assign wr_op = {wr, rd};

    // Update outputs full and empty
    assign full  = full_reg;
    assign empty = empty_reg;

    // FIFO control logic
    always @* begin
        // Default next states
        w_ptr_next = w_ptr_reg;
        r_ptr_next = r_ptr_reg;
        full_next  = full_reg;
        empty_next = empty_reg;

        // Handling operations
        case (wr_op)
            2'b00: begin
                // No operation
            end

            2'b01: begin
                // Read operation
                if (!empty_reg) begin
                    // If FIFO is not empty
                    r_ptr_next = r_ptr_succ; // Update read pointer
                    full_next  = 1'b0;       // After read, FIFO is not full
                    if (r_ptr_succ == w_ptr_reg)
                        empty_next = 1'b1;   // FIFO becomes empty
                end
            end

            2'b10: begin
                // Write operation
                if (!full_reg) begin
                    // If FIFO is not full
                    w_ptr_next = w_ptr_succ; // Update write pointer
                    empty_next = 1'b0;       // After write, FIFO is not empty
                    if (w_ptr_succ == r_ptr_reg)
                        full_next = 1'b1;    // FIFO becomes full
                end
            end

            default: begin
                // Simultaneous Read and Write
                w_ptr_next = w_ptr_succ; // Update write pointer
                r_ptr_next = r_ptr_succ; // Update read pointer
                // full_next and empty_next unchanged
            end
        endcase
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

fifo_parametrized UUT (
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
    $stop(0);
end
endmodule