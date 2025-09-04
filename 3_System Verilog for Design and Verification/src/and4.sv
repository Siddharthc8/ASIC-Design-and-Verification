`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/17/2024 10:56:09 AM
// Design Name: 
// Module Name: and4
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


module and4 (
  input [3:0] a,
  input [3:0] b,
  output reg [4:0] y,
  input clk
 
);
  
 always @(posedge clk) begin
    y <= a + b;
 end

endmodule
