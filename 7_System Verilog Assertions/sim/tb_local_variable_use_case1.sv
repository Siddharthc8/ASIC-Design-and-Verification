`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/06/2025 09:53:15 PM
// Design Name: 
// Module Name: tb_local_variable_use_case1
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


module tb_local_variable_use_case1();

 reg clk = 0;
 reg start = 0;
 
 
 always #5 clk =~clk;
 
 default clocking 
 @(posedge clk);
 endclocking
 
 //always #20 start = ~start;
 
 initial begin
 #20;
 start = 1;
 #60;
 start = 0;
 end
 
 property p1;
 integer count = 0;
 
 // $rose(start) |-> start[*1:$] ##1 !start;
 
 $rose(start) |-> (start, count++)[*1:$] ##1 (!start, $display("Count : %0d",count));
 
 // $rose(start) |-> (start[*1:$], count++) ##1 (!start, $display("Count : %0d",count));
 
 endproperty
 
 
 assert property(p1) $info("Suc at %0t",$time); else $error("Fail at %0t", $time);
 
 
 //assert property ($rose(start) |-> start[*1:14] ##1 !start) $info("Suc at %0t",$time);

 initial begin
 $dumpfile("dump.vcd");
 $dumpvars;
// $assertvacuousoff(0); 
 #120;
 $finish;
 end
 
 
endmodule