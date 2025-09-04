`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2024 02:01:27 AM
// Design Name: 
// Module Name: tb_a55
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


module tb_a55();
// Assume the class consists of three 8-bit data members a, b, and c. 
// Create a Custom Constructor that allows the user to update the value of these data members while adding a constructor to the class. 
// Test your code by adding the value of 2, 4, and 56 to a, b and c respectively.
    
    class Gen;
        
        bit [7:0] a;
        bit [7:0] b;
        bit [7:0] c;
        
        function new(input bit [7:0] a=0,input  bit [7:0] b=0,input bit [7:0] c=0);
            this.a = a;
            this.b = b;
            this.c = c;
        
        endfunction
    endclass
    
    Gen z;
    
    initial begin
        z = new(2,4,5);
        $display("a: %0d, b: %0d, c: %0d", z.a, z.b, z.c); 
    end
    
endmodule
