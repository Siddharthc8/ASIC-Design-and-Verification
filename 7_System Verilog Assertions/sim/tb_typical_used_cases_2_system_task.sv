`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/20/2024 12:21:39 PM
// Design Name: 
// Module Name: tb_typical_used_cases_2_system_task
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


module tb_typical_used_cases_2_system_task();

  reg a;
  reg clk = 0;
  reg rd;
  reg [7:0] addr;
 
 
 
  always#5 clk = ~clk;
  
  
  initial begin
  a = 0;
  #10;
  a = 1;
  #10;
  a = 0;
  #10;
  a = 1;  
  end
  
  
  initial begin
  rd = 0;
  #10;
  rd = 1;
  addr = 2;
  #20;
  rd = 0;
  #10;
  rd = 1;
  addr = 4;
  #20;
  rd = 0;
  #10;
  rd = 1;
  addr = 7;
  #10;
  addr = 9;
  #10;
  rd = 0;
  end
  
  initial begin
    #100;
    $finish;
  end
  
 
////A toggles
A1: assert property (@(posedge clk) ##1 $changed(a)) $info("Toggle suc at %0t",$time); else
$error("Toogle failed at %0t",$time);

 
////A Stable 
A2: assert property (@(posedge clk) ##1 $stable(a)) $info("Stable suc at %0t",$time); else
$error("Stable failed at %0t",$time); 
 
 
 /////rd assert , addr is stable for two clock tick
// Checks for riseing edge of rd and when you you non-overlapping it moves to the next clock and the "$stable" checks for that posedge and the previous posedge(which is our current posedge)
A3: assert property (@(posedge clk) $rose(rd) |=> $stable(addr)) $info("rd success at %0t",$time);
 
 
endmodule