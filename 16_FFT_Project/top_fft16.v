`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2024 11:03:42 AM
// Design Name: 
// Module Name: top_fft16
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_fft16
#(parameter DATA_WIDTH = 20) // Adjusted DATA_WIDTH to accommodate input range
(
    input clk,
    input reset,
    input [DATA_WIDTH*16-1:0] x_in_flat_real,
    input [DATA_WIDTH*16-1:0] x_in_flat_imag,
    output [DATA_WIDTH*16-1:0] x_out_flat_real,
    output [DATA_WIDTH*16-1:0] x_out_flat_imag
);
    // Instantiate the fft16 module
    fft16 #(DATA_WIDTH) fft_inst (
        .clk(clk),
        .reset(reset),
        .x_in_flat_real(x_in_flat_real),
        .x_in_flat_imag(x_in_flat_imag),
        .x_out_flat_real(x_out_flat_real),
        .x_out_flat_imag(x_out_flat_imag)
    );
endmodule

