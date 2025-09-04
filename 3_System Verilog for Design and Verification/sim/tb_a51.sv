`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 02:39:49 PM
// Design Name: 
// Module Name: tb_a51
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

class Assignment;
// Create a Class consisting of 3 data members each of unsigned integer type. 
// Initialize them to 45,78, and 90. Use the display function to print the values on the console.
    
    int unsigned d1 = 0;
    int unsigned d2 = 0;
    int unsigned d3 = 0;

endclass


module tb_a51();
    
    Assignment a = new();
    
    initial begin
        a.d1 = 45;
        a.d2 = 78;
        a.d3 = 90;
        
        $display("Values of data 1,2,3: %0d, %0d, %0d", a.d1, a.d2,a.d3);
    end
endmodule
