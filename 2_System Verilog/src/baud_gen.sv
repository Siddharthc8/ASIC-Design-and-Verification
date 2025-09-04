`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2024 08:05:15 PM
// Design Name: 
// Module Name: baud_gen
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


module baud_gen     //Basically a timer
    (
        input  logic clk, 
        input  logic reset,
        input  logic [10:0] dvsr,
        output tick
    );
    
    // Signal declaration
    logic [10:0] r_reg, r_next;
    
    // Register Body
    always_ff @(posedge clk, posedge reset)
    begin
        if(reset)
            r_reg <= 0;
        else
            r_reg <= r_next;
    end
    
    // Next state logic
    assign r_next = (r_reg==dvsr) ? 0: r_reg +1;
    
    // Ouptut logic
    assign tick = (r_reg==1);
    
endmodule
