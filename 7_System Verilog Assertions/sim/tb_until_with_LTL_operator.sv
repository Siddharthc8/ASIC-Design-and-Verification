`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2025 09:10:07 PM
// Design Name: 
// Module Name: tb_until_with_LTL_operator
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


module tb_until_with_LTL_operator();

  reg clk = 0, rst = 0, ce = 0;
  always #5 clk = ~clk;
  
  
  initial begin
    rst = 1;
    #30;
    rst = 1;
    #10;
    ce = 1;
    rst = 0;
    #10;
    rst = 0;
    #50;
    ce = 0;
  end
  
   // s_until gives a failure at 100 ie at the end of simulation
   initial A1: assert property (@(posedge clk) rst s_until ce) $info("Suc at %0t",$time);
   
   // Weirdly until gives success as the rst held true until the end of simulation even when ce never became high
   initial A2: assert property (@(posedge clk) rst until_with ce) $info("A2 Suc at %0t",$time);

  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
//    $assertvacuousoff(0);
    #100;
    $finish();
  end
  
 
endmodule