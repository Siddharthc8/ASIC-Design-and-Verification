`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/26/2024 05:51:47 PM
// Design Name: 
// Module Name: adder
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

module adder(
  input [3:0] a,b,
  output [4:0] y
);
  
  
  assign y = a + b;
  
endmodule
 
 
interface adder_if;
  logic [3:0] a;
  logic [3:0] b;
  logic [4:0] y;
  
endinterface
