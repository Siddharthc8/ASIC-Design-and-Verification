`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2024 07:32:33 PM
// Design Name: 
// Module Name: tb_rose_and_fell_system_task
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

 // NOTE: System tasks check in the prepone region
 // Rose evaluates x -> 1, 0 -> 1
 // Fell evaluates x -. 0, 1 -> 0
 // Multi-bit mode uses the LSB of the value to check for rose
 // Checks the prepone region
 // Evaluates once only when the transition occurs and NOT on every cycle

module tb_rose_and_fell_system_task();

 reg a = 1;
 reg b = 0;
 reg clk = 0;
 
 
 always #5 clk = ~clk;
 
 
 initial begin
 a = 1;
 #10;
 a = 0;
 #20;
 a = 1;
 #20;
 a = 0;
 end
 
  initial begin
 b = 4'b0100;
 #10;
 b = 4'b0101;
 #10;
 b = 4'b0100;
 #10;
 b = 4'b0101;
 #10;
 b = 4'b0100;
 #10;
 b = 4'b0101;
 #10;
 b = 4'b0000;
 
 end
 ////////////////////////////////////////////////////////////////////
 //                ROSE     N       FELL
 
 // NOTE: System tasks check in the prepone region
 
 // Rose evaluates x -> 1, 0 -> 1
 // Fell evaluates x -. 0, 1 -> 0
 // Single bit mode 
 
 always@(posedge clk)
 begin
 $info("Value of a :%0b and $rose(a) : %0b", $sampled(a), $rose(a));  // ROSE
 $info("Value of a :%0b and $fell(a) : %0b", $sampled(a), $fell(a));  //       FELL
 end 
 
 // Multi-bit mode uses the LSB of the value to check for rose
 always@(posedge clk)
 begin
 $info("Value of b :%0b and $rose(b) : %0b", $sampled(b), $rose(b));  // ROSE      
 $info("Value of b :%0b and $fell(b) : %0b", $sampled(b), $fell(b));  //       FELL                                                                 //       FELL
 end 
 
 // One other way to write $rose assertion
 assign c = $rose( a, @(posedge clk) );   // $rose return either T/F
 assign c = $fell( a, @(posedge clk) );   // $fell return either T/F

 
 /////////////////////////////////////////////////////////////////////

 initial begin
 $dumpfile("dump.vcd"); 
 $dumpvars;
 #120;
 $finish();
 end
 
 
endmodule