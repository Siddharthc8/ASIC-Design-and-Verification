`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2024 02:14:03 PM
// Design Name: 
// Module Name: D_FF_reset
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


module D_FF_reset(
    input D,
    input clk, 
    input clear_n, // Synchronous
    input reset_n, // Asynchronous
    output Q
    );
    
    reg Q_reg, Q_next;
    
    always @(negedge clk, negedge reset_n)
    begin
        Q_reg = Q_reg;  // Coding style
        
        if (!reset_n)
            Q_reg <= 1'b0;
        else 
            Q_reg <= Q_next;
    end
    
    always @(D, clear_n)
    begin
        Q_next = Q_reg;  // Coding style
        
        if(!clear_n)
            Q_next = 1'b0;
        else
            Q_next = D;
    end
    
    assign Q = Q_reg;
endmodule
