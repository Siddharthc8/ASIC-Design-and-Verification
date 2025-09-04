`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2024 02:33:21 PM
// Design Name: 
// Module Name: a21
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


module a21(
  input      [3:0] a,b,
  output reg [4:0] s
);
  
  
  always@(*)
    begin
      s = a + b;
    end
 
  
endmodule
