`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2024 06:03:51 PM
// Design Name: 
// Module Name: fft16
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


module fft16
#(parameter DATA_WIDTH = 20) // Ensure consistent DATA_WIDTH
(
    input clk,
    input reset,
    input [DATA_WIDTH*16-1:0] x_in_flat_real,
    input [DATA_WIDTH*16-1:0] x_in_flat_imag,
    output [DATA_WIDTH*16-1:0] x_out_flat_real,
    output [DATA_WIDTH*16-1:0] x_out_flat_imag
);

    // Internal wires for stage outputs
    wire [DATA_WIDTH*16-1:0] stage1_out_flat_real, stage1_out_flat_imag;
    wire [DATA_WIDTH*16-1:0] stage2_out_flat_real, stage2_out_flat_imag;
    wire [DATA_WIDTH*16-1:0] stage3_out_flat_real, stage3_out_flat_imag;

    // Pipeline registers between stages
    reg [DATA_WIDTH*16-1:0] stage1_out_reg_real, stage1_out_reg_imag;
    reg [DATA_WIDTH*16-1:0] stage2_out_reg_real, stage2_out_reg_imag;
    reg [DATA_WIDTH*16-1:0] stage3_out_reg_real, stage3_out_reg_imag;

    // Round 1
    round_1 #(DATA_WIDTH) r1 (
        .clk(clk),
        .x_in_flat_real(x_in_flat_real),
        .x_in_flat_imag(x_in_flat_imag),
        .x_out_flat_real(stage1_out_flat_real),
        .x_out_flat_imag(stage1_out_flat_imag)
    );

    // Pipeline registers after Round 1
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1_out_reg_real <= 0;
            stage1_out_reg_imag <= 0;
        end else begin
            stage1_out_reg_real <= stage1_out_flat_real;
            stage1_out_reg_imag <= stage1_out_flat_imag;
        end
    end

    // Round 2
    round_2 #(DATA_WIDTH) r2 (
        .clk(clk),
        .x_in_flat_real(stage1_out_reg_real),
        .x_in_flat_imag(stage1_out_reg_imag),
        .x_out_flat_real(stage2_out_flat_real),
        .x_out_flat_imag(stage2_out_flat_imag)
    );

    // Pipeline registers after Round 2
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage2_out_reg_real <= 0;
            stage2_out_reg_imag <= 0;
        end else begin
            stage2_out_reg_real <= stage2_out_flat_real;
            stage2_out_reg_imag <= stage2_out_flat_imag;
        end
    end

    // Round 3
    round_3 #(DATA_WIDTH) r3 (
        .clk(clk),
        .x_in_flat_real(stage2_out_reg_real),
        .x_in_flat_imag(stage2_out_reg_imag),
        .x_out_flat_real(stage3_out_flat_real),
        .x_out_flat_imag(stage3_out_flat_imag)
    );

    // Pipeline registers after Round 3
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage3_out_reg_real <= 0;
            stage3_out_reg_imag <= 0;
        end else begin
            stage3_out_reg_real <= stage3_out_flat_real;
            stage3_out_reg_imag <= stage3_out_flat_imag;
        end
    end

    // Round 4
    round_4 #(DATA_WIDTH) r4 (
        .clk(clk),
        .x_in_flat_real(stage3_out_reg_real),
        .x_in_flat_imag(stage3_out_reg_imag),
        .x_out_flat_real(x_out_flat_real),
        .x_out_flat_imag(x_out_flat_imag)
    );

endmodule




