`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2024 02:33:21 PM
// Design Name: 
// Module Name: a23
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


module a23(
input din, clk, rst,
output reg dout  
);
  
  always@(posedge clk)
    begin
      if(rst)
        dout <= 1'b0;
      else
        dout <= din;
    end
    
//  always @(posedge clk)
//  begin
//    A1 : assert property (@(posedge clk) rst |-> !dout) $info("A1: Assertion Passed at %0t", $time);
//    else $info("A1:Assertion Failed"); 
//    A2 : assert property (@(posedge clk) !rst |-> (dout == din)) $info("A2: Assertion Passed at %0t", $time);
//    else $info("A2:Assertion Failed"); 
//  end

    always@(posedge clk) begin
    
    if(rst)
    
    A1: assert(dout == 0) else $info("assertion passed at %0t", $time);
    
    else
    
    A2: assert(dout == din) else $error("assertion failed at %0t", $time);
    
    end
  
endmodule
