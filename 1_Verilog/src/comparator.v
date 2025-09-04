`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2024 12:09:43 AM
// Design Name: 
// Module Name: comparator
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


module comparator (a_gt_b, a_lt_b, a_eq_b, a, b);
parameter word_size=32;
input [word_size-1:0] a,b;
output a_gt_b, a_lt_b, a_eq_b;

assign a_gt_b = (a > b),
       a_lt_b = (a < b),
       a_eq_b = (a == b);

endmodule
