`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/02/2025 01:23:39 PM
// Design Name: 
// Module Name: tb_goto_vs_non_consecutive_operator
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


module tb_goto_vs_non_consecutive_operator();

 reg clk = 0;
 
 reg a = 0;
 reg b = 0;
 
 
 always #5 clk = ~clk;
 
 initial begin
 #15;
 a = 1;
 #10;
 a = 0;
 
 end
 
 initial begin
 #20;
 b = 1;
 repeat(3) @(posedge clk); 
 b = 0; 
 
 #50;
 b = 1;
 #10;
 b = 0;
 end
 
 // Non-consecutive operator considers the delay as the min dealy after which anytime the tail expression should be true 
 A1: assert property (@(posedge clk) $rose(a) |-> b[=3] ##1 b ) $info("Non-con Suc @ %0t",$time);
 
 
 // Goto operator expects the tail expression to be true immediately after the delay
 A2: assert property (@(posedge clk) $rose(a) |-> b[->3] ##1 b ) $info("GOTO Suc @ %0t",$time);
 
 initial begin 
 $dumpfile("dump.vcd");
 $dumpvars;
 #150;
 $finish();
 end
 
endmodule