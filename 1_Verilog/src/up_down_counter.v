`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2024 11:36:55 PM
// Design Name: 
// Module Name: up_down_counter
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


module up_down_counter
    #(parameter bits = 4)(
    input clk,
    input reset_n,
    input enable,
    input up,         // Asserted counts up else counts down
    output [bits-1:0] Q
    );
    
   reg [bits-1:0] Q_reg, Q_next;
   
   always @(posedge clk, negedge reset_n)
   begin
        if (!reset_n)
            Q_reg = 0;
        else if(enable)
            Q_reg <= Q_next;
        else
            Q_reg <= Q_reg;
   end
   
   always @(*)
   begin    
            Q_next = Q_reg;
        if(up)
            Q_next = Q_reg + 1;
        else 
            Q_next = Q_reg -1;
   end
   
   assign Q = Q_reg;
   
   
endmodule
