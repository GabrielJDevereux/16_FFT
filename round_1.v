`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2024 06:03:51 PM
// Design Name: 
// Module Name: round_1
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

module round_1
#(parameter DATA_WIDTH = 20)
(
    input clk,
    input [DATA_WIDTH*16-1:0] x_in_flat_real,
    input [DATA_WIDTH*16-1:0] x_in_flat_imag,
    output [DATA_WIDTH*16-1:0] x_out_flat_real,
    output [DATA_WIDTH*16-1:0] x_out_flat_imag
);
    // Unflatten inputs
    wire signed [DATA_WIDTH-1:0] x_in_real [15:0];
    wire signed [DATA_WIDTH-1:0] x_in_imag [15:0];
    wire signed [DATA_WIDTH-1:0] x_out_real [15:0];
    wire signed [DATA_WIDTH-1:0] x_out_imag [15:0];

    genvar i;
    generate
        // Unflatten input arrays
        for (i = 0; i < 16; i = i + 1) begin : unflatten_input
            assign x_in_real[i] = x_in_flat_real[DATA_WIDTH*(16 - i)-1 -: DATA_WIDTH];
            assign x_in_imag[i] = x_in_flat_imag[DATA_WIDTH*(16 - i)-1 -: DATA_WIDTH];
        end
    endgenerate

    // Twiddle factors for round 1 (all W^0 = 1 + j0)
    localparam signed [DATA_WIDTH-1:0] W_real = 20'sh7FFFF; // 1.0 in Q19
    localparam signed [DATA_WIDTH-1:0] W_imag = 20'sh00000; // 0.0 in Q19

    // Butterfly operations
    generate
        for (i = 0; i < 8; i = i + 1) begin : butterfly_stage
            butterfly #(DATA_WIDTH) bf (
                .clk(clk),
                .x0_real(x_in_real[i]),
                .x0_imag(x_in_imag[i]),
                .x1_real(x_in_real[i+8]),
                .x1_imag(x_in_imag[i+8]),
                .twiddle_real(W_real),
                .twiddle_imag(W_imag),
                .y0_real(x_out_real[i]),
                .y0_imag(x_out_imag[i]),
                .y1_real(x_out_real[i+8]),
                .y1_imag(x_out_imag[i+8])
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






