`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2024 11:08:47 AM
// Design Name: 
// Module Name: tb_a64
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


module tb_a64();
// Take the help of pseudo-random number generator to generate values for wr and rst signal. 
// rst should be low for apprx. 30% of time whie wr should be high for apprx. 50% of time. 
// Verify your code for 20 iterations by sending values of both wr and rst on a console.
class First;

    rand bit wr; 
    rand bit rst;
    
    constraint data { 
    rst dist { 0 := 30 , 1 := 70 };
    wr dist { 0 := 50 , 1 := 50 };
    }
    
endclass

    First f;
    
    initial begin
        f = new();
        
      for(int i = 0; i < 20; i++) begin
      f.randomize();
      $display("Value of wr(:=) : %0d and rst(:=) : %0d", f.wr, f.rst);    
    end
    end

endmodule
