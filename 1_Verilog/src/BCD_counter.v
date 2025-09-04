`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2024 08:40:53 PM
// Design Name: 
// Module Name: BCD_counter
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


module BCD_counter(
    input clk,
    input reset_n,
    input enable,
    output saturation,   // to cascade
    output [3:0] Q
    );
    
    reg [3:0] Q_reg, Q_next;
    
    always @(posedge clk, negedge reset_n)
    begin
        if(!reset_n)
            Q_reg <= 'b0;
        else if(enable)
            Q_reg <= Q_next;
        else
            Q_reg = Q_reg;
    end
    
    // Next State Logic
    assign saturation = Q_reg == 9;
    
    always @(*)
    begin
        Q_next = saturation? 'b0: Q_reg + 1;
    end
    
    
    // Output Logic
    assign Q = Q_reg;
endmodule












