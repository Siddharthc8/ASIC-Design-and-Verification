`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/20/2024 12:15:23 PM
// Design Name: 
// Module Name: tb_countbits_system_task
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


module tb_countbits_system_task();

  reg [3:0] a; 
  reg clk = 0; 
  
  
  always #5 clk = ~clk; ///Generation of 10 ns Clock
  
  
  ////Random Stimuli for a
  initial begin
    #4;
    a = 4'b0001;
    #10;
    a = 4'b011x;
    #10;
    a = 4'b1111;
    #10;
    a = 4'b110z;
    #10;
    a = 4'b0000;
    #10;
    a = 4'bzzzx;
  end
  
  initial begin
    #70;
    $finish;
  end
 
  
 
 
//////Counting number of ones present in the variable
//    always@(posedge clk)
//      begin
//        $display("Value of a: %4b , $countones : %0d at time: %0t", $sampled(a),$countones(a), $time);
//      end
  
  
 
////Count the number of bits where we see match to the value specified inside the funtion
// Takes two arguments the variable to be checked and the bit to be counted
// Returns the numbers of the mentioned bit occurance
    always@(posedge clk)
      begin
        $display("Value of a: %b , $countbits : %0d at time: %0t", $sampled(a),$countbits(a,0), $time);
      end

 
 
  
 
endmodule