`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2025 09:07:37 PM
// Design Name: 
// Module Name: add_sv_assert
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


module add_sv_assert
(
input [7:0] a,b,input clk,
input [8:0] sum 
);
 
  SUM_CHECK: assert property (@(posedge clk) $changed(sum) |-> (sum == (a + b)));
    
  SUM_VALID: assert property (@(posedge clk) !$isunknown(sum)); 
 
  A_VALID: assert property (@(posedge clk) !$isunknown(a)); 
  
  B_VALID:assert property (@(posedge clk) !$isunknown(b));   
 
endmodule