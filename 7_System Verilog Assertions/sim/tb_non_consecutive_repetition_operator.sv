`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/01/2025 06:49:39 PM
// Design Name: 
// Module Name: tb_non_consecutive_repetition_operator
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


module tb_non_consecutive_repetition_operator();

 reg clk = 0;
 
 reg a = 0;
 reg b = 0;
 reg c = 0;
 
 reg temp = 0;
 
 
 always #5 clk = ~clk;
 
 initial begin
 #15;
 a = 1;
 #10;
 a = 0;
 
 end
 
 initial begin
 temp = 1;
 #185;
 temp = 0;
 end
 
 initial begin
 #20;
 b = 1;
 repeat(3) @(posedge clk); 
 b = 0; 
 end
 
 initial begin
 #94;
 c = 1;
 #10;
 c = 0;
 
 end
 
 
  // Non_consecutive repetition operator "=" 
  // Goto operator "->"
  A1: assert property (@(posedge clk) $rose(a) |-> strong (b[=3]) ) $info("A1 Non-con Suc @ %0t",$time);
  A2: assert property (@(posedge clk) $rose(a) |-> strong (b[->3]) ) $info("A2 GOTO Suc @ %0t",$time);
 
 
  A3: assert property (@(posedge clk) $rose(a) |-> temp throughout b[=3] ) $info("A3 Non-con Suc @ %0t",$time);
  A4: assert property (@(posedge clk) $rose(a) |-> temp throughout b[->3] ) $info("A4 GOTO Suc @ %0t",$time);
  
  A5: assert property (@(posedge clk) $rose(a) |-> strong( b[=3:5] ) ) $info("A5 Non-con Suc @ %0t",$time);
  A6: assert property (@(posedge clk) $rose(a) |-> strong( b[->3:5]) ) $info("A6 GOTO Suc @ %0t",$time);
 
 initial begin 
 $dumpfile("dump.vcd");
 $dumpvars;
// $assertvacuousoff(0);
 #200;
 $finish();
 end
 
endmodule