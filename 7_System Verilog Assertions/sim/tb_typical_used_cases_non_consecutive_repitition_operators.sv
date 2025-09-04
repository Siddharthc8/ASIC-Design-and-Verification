`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/02/2025 10:21:14 AM
// Design Name: 
// Module Name: tb_typical_used_cases_non_consecutive_repitition_operators
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


module tb_typical_used_cases_non_consecutive_repitition_operators();

 reg clk = 0;
 
 reg rd = 0;
 reg wr = 0;
 reg rst = 0;
 
 reg done = 0;
 
 int delayw,delayr;
 
 always #5 clk = ~clk;
 
 initial begin
 rst = 1;
 #20;
 rst = 0; 
 end
 
 task write();
 for(int i = 0; i<5 ; i++) 
 begin
 @(negedge clk);
 delayw = $urandom_range(1,3);
 wr = 1;
 @(posedge clk);
 wr = 0; 
 repeat(delayw) @(posedge clk); 
 end
 endtask
 
 task read();
 for(int i = 0; i<5 ; i++) 
 begin
 @(negedge clk);
 delayr = $urandom_range(1,3);
 repeat(delayr) @(posedge clk);
 rd = 1;
 repeat(2)@(posedge clk);
 rd = 0; 
 end 
 endtask
 
 
 initial begin
 #20;
 fork
 write();
 read();
 join
 end
 
 initial begin
 #295;
 done = 1;
 #10;
 done = 0;
 
 end
 
 /////////////consecutive repetition operator
A1: assert property (@(posedge clk) $rose(rd) |-> rd[*2] ##1 !rd ) $info("RD high for two Clock ticks @ %0t",$time); 
 
 /////////// Non-consecutive rep
A2 : assert property (@(posedge clk) $fell(rst) |-> wr[=5] ) $info("Five WR cycles Success @ %0t", $time);
A3 : assert property (@(posedge clk) $fell(rst) |-> $rose(rd)[=5]) $info("Five RD Cycles Success @ %0t", $time);
 
 /////////////Goto Operator
A4 : assert property (@(posedge clk) $fell(rst) |-> $rose(wr)[->5] ##1 !wr[*1:$] ##1 $rose(done)) $info("WR Zero after five cycles @ %0t", $time); 
A5 : assert property (@(posedge clk) $fell(rst) |-> $rose(rd)[->5] ##2 !rd[*1:$] ##1 $rose(done)) $info("RD Zero after five cycles @ %0t", $time);
 
 
 initial begin 
 $dumpfile("dump.vcd");
 $dumpvars;
 $assertvacuousoff(0);
 #310;
 $finish();
 end
 
endmodule
