`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2024 10:52:39 AM
// Design Name: 
// Module Name: mod_counter_hardcoded
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


module mod_counter_hardcoded
    #(parameter n=4)(
    input clk,
    input reset_n,
    input enable,
    output [n-1:0] Q
    );
    
    reg [n-1:0] Q_reg, Q_next;
    
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














