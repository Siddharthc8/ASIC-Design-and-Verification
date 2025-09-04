`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 08:38:30 AM
// Design Name: 
// Module Name: tb_multi_decade_counter
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


module tb_multi_decade_counter();

    // Input out declaration
    reg clk, reset_n, enable;
    wire saturation;
    wire [3:0] ones, tens, hundreds;
    
    // Module Instantiation
    multi_decade_counter uut(
       .clk(clk),        
       .reset_n(reset_n),    
       .enable(enable),     
       .saturation(saturation),
       .ones(ones),
       .tens(tens),
       .hundreds(hundreds)   
    );
    
    // Clock generation
    localparam T =4;
    always begin
        clk = 1'b0;
        #(T/2);
        clk = 1'b1;
        #(T/2);
    end    
   
    // Generate Stimuli
    initial begin
    
        reset_n = 1'b0;
        #2;
        reset_n = 1'b1;
        #2;
        enable = 1'b1;
        
        repeat(1000) @(negedge clk);
        #10 $stop;
    end
    
endmodule
