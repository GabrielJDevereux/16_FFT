`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2024 08:05:56 PM
// Design Name: 
// Module Name: fft_system
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


module butterfly
#(parameter DATA_WIDTH = 20)
(
    input clk,
    input signed [DATA_WIDTH-1:0] x0_real,
    input signed [DATA_WIDTH-1:0] x0_imag,
    input signed [DATA_WIDTH-1:0] x1_real,
    input signed [DATA_WIDTH-1:0] x1_imag,
    input signed [DATA_WIDTH-1:0] twiddle_real,
    input signed [DATA_WIDTH-1:0] twiddle_imag,
    output reg signed [DATA_WIDTH-1:0] y0_real,
    output reg signed [DATA_WIDTH-1:0] y0_imag,
    output reg signed [DATA_WIDTH-1:0] y1_real,
    output reg signed [DATA_WIDTH-1:0] y1_imag
);

    // Extended bit width for intermediate calculations
    reg signed [2*DATA_WIDTH-1:0] mult1, mult2, mult3, mult4;
    reg signed [2*DATA_WIDTH:0] mult_real_temp, mult_imag_temp;

    // Pipeline stages for better performance
    reg signed [DATA_WIDTH-1:0] x0_real_reg, x0_imag_reg;
    reg signed [DATA_WIDTH-1:0] x1_real_reg, x1_imag_reg;
    reg signed [DATA_WIDTH-1:0] twiddle_real_reg, twiddle_imag_reg;

    always @(posedge clk) begin
        // Stage 1: Register inputs
        x0_real_reg <= x0_real;
        x0_imag_reg <= x0_imag;
        x1_real_reg <= x1_real;
        x1_imag_reg <= x1_imag;
        twiddle_real_reg <= twiddle_real;
        twiddle_imag_reg <= twiddle_imag;
    end

    always @(posedge clk) begin
        // Stage 2: Multiply
        mult1 <= x1_real_reg * twiddle_real_reg; // x1_real * W_real
        mult2 <= x1_imag_reg * twiddle_imag_reg; // x1_imag * W_imag
        mult3 <= x1_real_reg * twiddle_imag_reg; // x1_real * W_imag
        mult4 <= x1_imag_reg * twiddle_real_reg; // x1_imag * W_real
    end

    always @(posedge clk) begin
        // Stage 3: Compute temp results
        mult_real_temp <= mult1 - mult2; // Real part of multiplication
        mult_imag_temp <= mult3 + mult4; // Imaginary part of multiplication
    end

    always @(posedge clk) begin
        // Stage 4: Scale down and compute outputs
        y0_real <= x0_real_reg + (mult_real_temp >>> (DATA_WIDTH - 1));
        y0_imag <= x0_imag_reg + (mult_imag_temp >>> (DATA_WIDTH - 1));
        y1_real <= x0_real_reg - (mult_real_temp >>> (DATA_WIDTH - 1));
        y1_imag <= x0_imag_reg - (mult_imag_temp >>> (DATA_WIDTH - 1));
    end

endmodule








