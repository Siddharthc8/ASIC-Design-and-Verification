`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 06:37:11 PM
// Design Name: 
// Module Name: tb_timer_parameter
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


module tb_timer_parameter();

    localparam saturation_value = 255;
    localparam n = $clog2(saturation_value);
    
    reg clk, reset_n, enable;
    wire saturation; 
    
    // Instantiation 
    timer_parameter #(.saturation_value(saturation_value)) uut(
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .saturation(saturation)
        );
        
    // Clock generation
    localparam T = 10;
    always
    begin
    clk = 1'b0;
    #(T/2);
    clk = 1'b1;
    #(T/2);
    end
    
    initial begin
        reset_n = 1'b0;
        #2;
        reset_n = 1'b1;
        #2;
        enable = 1'b1;
        
        repeat(100000) @(negedge clk);
        #20;
    end

endmodule
