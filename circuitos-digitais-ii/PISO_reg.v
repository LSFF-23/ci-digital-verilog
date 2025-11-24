module PISO_reg #(parameter num_bits = 8) (
    input reset,
    input clk,
    input load,
    input dir,
    input [num_bits-1:0] data_in,
    output data_out
);

// Internal register to hold the data
reg [num_bits-1:0] reg_data = 0;

// Assign the output data based on the direction
assign data_out = (dir == 1'b0) ? reg_data[0] : reg_data[num_bits-1];

// Process to handle the data movement
always @(posedge clk or posedge reset) begin
    if (reset) begin
        reg_data <= 0;   // Reset the register to 0
    end else if (load) begin
        reg_data <= data_in; // Load the input data into the register
    end else if (dir) begin
        reg_data <= {reg_data[num_bits-2:0], 1'b0}; // Shift left (with a 0 inserted)
    end else begin
        reg_data <= {1'b0, reg_data[num_bits-1:1]}; // Shift right (with a 0 inserted)
    end
end

endmodule

module PISO_reg_tb;
reg reset, clk, load, dir_left, dir_right;
reg [7:0] data_in_left, data_in_right;
wire data_out_left, data_out_right;

PISO_reg dut_shift_left (reset, clk, load, dir_left, data_in_left, data_out_left);
PISO_reg dut_shift_right (reset, clk, load, dir_right, data_in_right, data_out_right);

initial begin
    clk = 0; reset = 0; load = 0; 
    dir_left = 0; dir_right = 0; 
    data_in_left = 0; data_in_right = 0;
end

always #1 clk = !clk;

initial begin
    #1 load = 1; data_in_left = 8'b1111_0000; data_in_right = 8'b1111_0000;
    #1 load = 0;

    #1 dir_left = 0; dir_right = 1;
    #17 $finish(0);
end

endmodule