`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/11/2025 12:04:36 AM
// Design Name: 
// Module Name: priority_encoder
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


module priority_encoder
(
  input [3:0]y,
  output reg [1:0] a
);
  
  always@(*)
  begin
   
  casez(y)
  4'b0001 :  a = 2'b00;
  4'b001? :  a = 2'b01; // 0010 0011
  4'b01?? :  a = 2'b10; // 0100 0101 0110 0111
  4'b1??? :  a = 2'b11; // 1000 1001 1010 1011
 
  default:a = 2'bzz;
  endcase
 end
  
endmodule