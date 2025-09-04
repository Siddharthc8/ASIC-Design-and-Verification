`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/11/2025 12:15:08 AM
// Design Name: 
// Module Name: counter_4
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


module counter_4
(
input clk, en,
  output [3:0] dout 
);
  
  reg [3:0] temp = 0;
 
  always@(posedge clk)
    begin
      if(!en)
         temp <= 0;
      else
        temp <= temp + 1;
    end
  
assign dout = temp;  
  
endmodule
