`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2024 06:03:51 PM
// Design Name: 
// Module Name: round_4
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


module round_4
#(parameter DATA_WIDTH = 20)
(
    input clk,
    input [DATA_WIDTH*16-1:0] x_in_flat_real,
    input [DATA_WIDTH*16-1:0] x_in_flat_imag,
    output [DATA_WIDTH*16-1:0] x_out_flat_real,
    output [DATA_WIDTH*16-1:0] x_out_flat_imag
);
    // Unflatten inputs
    wire signed [DATA_WIDTH-1:0] x_in_real [0:15];
    wire signed [DATA_WIDTH-1:0] x_in_imag [0:15];
    wire signed [DATA_WIDTH-1:0] x_out_real [0:15];
    wire signed [DATA_WIDTH-1:0] x_out_imag [0:15];

    genvar i;
    generate
        // Unflatten input arrays
        for (i = 0; i < 16; i = i + 1) begin : unflatten_input
            assign x_in_real[i] = x_in_flat_real[DATA_WIDTH*(16 - i)-1 -: DATA_WIDTH];
            assign x_in_imag[i] = x_in_flat_imag[DATA_WIDTH*(16 - i)-1 -: DATA_WIDTH];
        end
    endgenerate

    // Twiddle factors for round 4
    wire signed [DATA_WIDTH-1:0] W_real [0:7];
    wire signed [DATA_WIDTH-1:0] W_imag [0:7];

    assign W_real[0] = 20'sd524287;    // cos(0°)
    assign W_imag[0] = 20'sd0;         // -sin(0°)
    assign W_real[1] = 20'sd513239;    // cos(11.25°)
    assign W_imag[1] = -20'sd102579;   // -sin(11.25°)
    assign W_real[2] = 20'sd484097;    // cos(22.5°)
    assign W_imag[2] = -20'sd200661;   // -sin(22.5°)
    assign W_real[3] = 20'sd438378;    // cos(33.75°)
    assign W_imag[3] = -20'sd293895;   // -sin(33.75°)
    assign W_real[4] = 20'sd370728;    // cos(45°)
    assign W_imag[4] = -20'sd370728;   // -sin(45°)
    assign W_real[5] = 20'sd293895;    // cos(56.25°)
    assign W_imag[5] = -20'sd438378;   // -sin(56.25°)
    assign W_real[6] = 20'sd200661;    // cos(67.5°)
    assign W_imag[6] = -20'sd484097;   // -sin(67.5°)
    assign W_real[7] = 20'sd102579;    // cos(78.75°)
    assign W_imag[7] = -20'sd513239;   // -sin(78.75°)

    // Butterfly operations
    generate
        for (i = 0; i < 8; i = i + 1) begin : butterfly_stage
            butterfly #(DATA_WIDTH) bf (
                .clk(clk),
                .x0_real(x_in_real[2*i]),
                .x0_imag(x_in_imag[2*i]),
                .x1_real(x_in_real[2*i+1]),
                .x1_imag(x_in_imag[2*i+1]),
                .twiddle_real(W_real[i]),
                .twiddle_imag(W_imag[i]),
                .y0_real(x_out_real[2*i]),
                .y0_imag(x_out_imag[2*i]),
                .y1_real(x_out_real[2*i+1]),
                .y1_imag(x_out_imag[2*i+1])
            );
        end
    endgenerate

    // Flatten outputs
    generate
        for (i = 0; i < 16; i = i + 1) begin : flatten_output
            assign x_out_flat_real[DATA_WIDTH*(16 - i)-1 -: DATA_WIDTH] = x_out_real[i];
            assign x_out_flat_imag[DATA_WIDTH*(16 - i)-1 -: DATA_WIDTH] = x_out_imag[i];
        end
    endgenerate
endmodule






