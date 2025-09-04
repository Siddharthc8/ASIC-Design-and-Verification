`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/02/2024 06:00:10 PM
// Design Name: 
// Module Name: dff
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


module dff(
input clk,
input rst,
input din,  
output reg dout  
);
  
  always@(posedge clk)
    begin
      if(rst)
         dout <= 1'b0;
      else
         dout <= din;
    end
  
endmodule
 
//////////////////////////////////////////////////
 
interface dff_if;
  logic clk;
  logic rst;
  logic din;
  logic dout;
endinterface
