`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2024 03:37:50 PM
// Design Name: 
// Module Name: simple_register_load_nbit
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


module simple_register_load_nbit
    #(parameter n=4)
(
    input clk,
    input load,
    input [n-1:0] I, 
    output [n-1:0] Q
    );

// Behavioral Method
    reg [n-1:0] Q_reg, Q_next;
    
    always @(posedge clk)
    begin
        Q_reg <= Q_next;
    end
    
// Next state logic 
    always @(I, load)
    begin
        if(load)
            Q_next = I;
        else 
            Q_next = Q_reg; 
    end 
endmodule
