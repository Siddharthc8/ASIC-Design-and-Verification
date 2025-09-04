`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2024 02:33:21 PM
// Design Name: 
// Module Name: a22
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


module a22(
input [3:0] a,b,
output [3:0] y
);
 
assign y = a && b;
 
///////////Add your code here
 
 always @(*)
 begin
    A1: assert (y == (a&&b)) $info("A1: Assertion Passed at %0t, a = %0d, b = %0d, y = %0d", $time, a, b, y);
    else $info("A1:Assertion Failed");
 end
 
/////////End your code here

endmodule
