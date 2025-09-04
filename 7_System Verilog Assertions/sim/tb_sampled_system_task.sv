`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2024 12:22:57 PM
// Design Name: 
// Module Name: tb_sampled_system_task
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


module tb_sampled_system_task();

 reg a = 1;
 reg clk = 0;
 
 
 
 always #5 clk = ~clk;
 
 always #5 a = ~a;
 
 
 always @(posedge clk)
 begin
 $info("Value of a :%b and $sampled(a) :%b ", a, $sampled(a)); 
 end
 
 // By default Concurrent assertion evaluates in the prepone region and not in active region aka reactive region
 // So there's no need for using $sampled inside the assertion 
 // But the reporting macros should use $sampled to ouput the exact data captured
 assert property (@(posedge clk ) (a == $sampled(a))) $info("Suc at %0t with a : %0b",$time, $sampled(a)); 
 
 initial begin
 $dumpfile("dump.vcd"); 
 $dumpvars;
 $assertvacuousoff(0);
 #50;
 $finish();
 end
 
endmodule