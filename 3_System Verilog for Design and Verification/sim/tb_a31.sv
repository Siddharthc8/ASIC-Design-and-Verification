`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 06:14:58 PM
// Design Name: 
// Module Name: a31
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


module tb_a31();
/////    Assume you have four variables ( a, b,c, and d )  in your testbench top. a and b are of the 8-bit reg type, 
/////    while c and d are of the integer type. initialize a,b,c, and d to values of 12, 34, 67, and 255 respectively. 
/////    Add a code to print the values of all the variables after 12 nSec.


    byte a, b;               // coorection made from reg [7:0] looking at other students' solutions
    integer c ,d;
    time fixed_time = 0;
    
    initial begin
        a = 12;
        b = 34;
        c = 67;
        d = 255;
    end
    
    initial begin
        #12;
        fixed_time = $time();
        $display("a: %0d, b: %0d, c: %0d, d: %0d @ simtime: %0t", a, b, c, d, fixed_time);
        $finish;
    end
endmodule
