`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2024 12:46:20 AM
// Design Name: 
// Module Name: arithmetic_operators
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


module arithmetic_operators
#(parameter n=4)
(
    input [n-1:0] x,
    input [n-1:0] y,
    output [n-1:0] sum,
    output overflow, cout
    );
    
    assign {cout,sum} = x + y;
    assign overflow = (x[n - 1] & y[n - 1] & ~sum[n - 1]) | (~x[n - 1] & y[n - 1]& sum[n - 1]);
    
endmodule


































