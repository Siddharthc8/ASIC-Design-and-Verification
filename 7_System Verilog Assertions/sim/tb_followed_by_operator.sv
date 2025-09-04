`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2025 09:31:39 PM
// Design Name: 
// Module Name: tb_followed_by_operator
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


module tb_followed_by_operator();

  reg clk = 0, rst = 0, ce = 0;
  always #5 clk = ~clk;
  
  
  initial begin
    rst = 0;
    #10;
    rst = 1;
    #20;
    ce = 1;
    rst = 0;
    #20;
    ce = 0;
  end
  
  
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
   // $assertvacuousoff(0);
    #50;
    $finish();
  end
  
  // General NOTE : The "followed by" Checks on every clock node irrespective of the antecedent
  
  // Gives vacuouos success
  initial A1 : assert property (@(posedge clk) rst[*2] |-> ##1 ce[*2]) $info("A1 Suc at %0t",$time); 
  
  initial A2 : assert property (@(posedge clk) rst[*2] |=> ce[*2]) $info("A2 Suc at %0t",$time);
    
  // Does not give vacuous success
  initial A3 : assert property (@(posedge clk) rst[*2] #-# ##1 ce[*2])$info("A3 Suc at %0t",$time); 
  
  initial A4 : assert property (@(posedge clk) rst[*2] #=# ce[*2])$info("A4 Suc at %0t",$time); 
  
    
    
endmodule