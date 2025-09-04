`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2024 08:44:50 PM
// Design Name: 
// Module Name: tb_rising_edge_detect
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


module tb_rising_edge_detect(
    );
    
    // Declarations
    localparam T = 10; // Clk
    
    logic clk, reset, level;
    logic tick_mealy, tick_moore;       
    
    // Mealy
    rising_edge_detect_mealy mealy_uut(
        .tick(tick_mealy),
        .*        
    );
    
    rising_edge_detect_moore moore_uut(
        .tick(tick_moore),
        .*        
    );
    
    
    // Test vector
    // 10ns clock always
    
    always
    begin
        clk = 1'b1;
        #(T/2);
        clk = 1'b0;
        #(T/2);
    end
    
    
    // Reset for first half cycle
    initial 
    begin
        reset = 1'b1;
        #(T/2);
        reset = 1'b0;
    end
    
    // Stimuli just the clk
    initial 
    begin
        repeat(3) @(negedge clk);
        #2;
        level = 1'b1;
        
        @(negedge clk);
        level = 1'b0;
        
        repeat(4) @(negedge clk);
        level = 1'b1;
        
        @(posedge clk);
        level = 1'b0;
        
        repeat(3) @(posedge clk);
        
        $finish;
    end
   
endmodule
