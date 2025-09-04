`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/02/2024 05:39:32 PM
// Design Name: 
// Module Name: multiplier
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


module multiplier(
  input [3:0] a,b,
  output [7:0] y
);
   
assign y = a * b;
  
endmodule
 
 
///////////////////////////////////////////
 
interface mul_if;
  logic [3:0] a;
  logic [3:0] b;
  logic [7:0] y;
  
endinterface