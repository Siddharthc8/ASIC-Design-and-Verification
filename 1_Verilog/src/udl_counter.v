`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2024 11:57:54 PM
// Design Name: 
// Module Name: udl_counter
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


module udl_counter  // Up Down Load Counter
    #(parameter bits = 4)(
    input clk,
    input reset_n,
    input enable,
    input up,
    input load,
    input [bits-1:0] D,         // Load data
    output [bits-1:0] Q
    );
    
    reg [bits-1:0] Q_next, Q_reg;
    
   always @(posedge clk, negedge reset_n)
   begin
        if (!reset_n)
            Q_reg = 0;
        else if(enable)
            Q_reg <= Q_next;
        else
            Q_reg <= Q_reg;
   end
   
   always @(Q_reg, up, load, D)
   begin    
            Q_next = Q_reg;
        casex({load,up})
        2'b00: Q_next = Q_reg - 1;
        2'b01: Q_next = Q_reg + 1;
        2'b1x: Q_next = D;           // case x treats x like don't care so it doesn't matter what the value for x is
        default: Q_next = Q_reg;
        endcase
   end
   
   assign Q = Q_reg;
   
endmodule
