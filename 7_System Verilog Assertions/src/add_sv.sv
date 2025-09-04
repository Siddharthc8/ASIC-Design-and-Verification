`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2025 09:06:50 PM
// Design Name: 
// Module Name: add_sv
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


module add_sv
(
 input [7:0] a,b,input clk,
 output reg [8:0] sum 
);
 
  always@(posedge clk) begin
    sum <= a + b;
  end
 
endmodule
 
 
interface add_sv_if();
logic clk;  
logic [7:0] a;
logic [7:0] b;
logic [8:0] sum;
endinterface
