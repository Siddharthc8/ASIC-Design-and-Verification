`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/06/2025 06:12:38 PM
// Design Name: 
// Module Name: tb_local_variables
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


module tb_local_variables();

 reg clk = 0;
 reg start = 0;
 
 
 always #5 clk =~clk;
 
 default clocking 
 @(posedge clk);
 endclocking
 
 always #20 start = ~start;
 
 property p1;
 
    int count = 0;
    // Creates three separate threads for all 3 values of $rose(start) so the count is 1 for each occurance
    ($rose(start), count = count+1, $display("P1 Value of count: %0d",count));
    
 endproperty
 
 assert property (@(posedge clk) p1 ) $info("Suc at %0t",$time); else $error("Fail at %0t", $time);
 
 //-----------------------------------------------------------------------------
 property p2;
 
    logic [1:0] count = 0 ;
 
    // $rose(start) |-> ## [1:$] $rose(start) ## [1:$] $rose(start);  // Example of how the assertion would look like without local variable 
    
    // Gives the count only for the last thread ie three as we have only mentioned display for that
    ($rose(start), count = 1) |-> ## [1:$] ($rose(start), count = count + 1) ##[1:$] ($rose(start), count = count + 1, $display("P2 Count : %0d", count) ) ; 
 
 endproperty
 
 // Gives success only for the first thread tgat ends at 105ns in our case. Using a strong qualifier may gives pass/fail action for rest two threads 
 assert property (@(posedge clk) p2 ) $info("Suc @ %0t", $time); else $error("Fail at %0t", $time);
 
 
 initial begin
 $dumpfile("dump.vcd");
 $dumpvars;
// $assertvacuousoff(0); 
 #130;
 $finish;
 end
 
 
endmodule