`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2024 10:11:29 PM
// Design Name: 
// Module Name: up_counter
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


module up_counter
    #(parameter bits = 4)(
    input clk,
    input reset_n,
    output [bits-1:0] Q
    );
    
    reg [bits-1:0] Q_reg, Q_next;
    
    always @(posedge clk, negedge reset_n)
    begin
        if(!reset_n)
            Q_reg <= 0;
        else
            Q_reg <= Q_next;
    end
    
    always @(Q_reg)
    begin
        Q_next = Q_reg + 1;
    end
    
    assign Q = Q_reg;
    
endmodule









