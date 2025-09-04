`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/20/2024 01:14:46 PM
// Design Name: 
// Module Name: tb_a61
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


module tb_a61;

  reg rd = 0;
  reg rst = 1;
  reg clk = 0;
  
  always #5 clk = ~clk;
  
  initial begin
    #40;
    rst = 0;
    rd = 1;
    #20;
    rd = 0;
    rst = 1;
    #10;
    rst = 0;
  end
 
 
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
//    $assertvacuousoff(0);
    #120;
    $finish();
  end
 
 A1: assert property( @(posedge clk) $fell(rst) |=> rd ) $info("Suc at %0t", $time);
// else $error (" Fail at %0t", $time);
                              
endmodule
