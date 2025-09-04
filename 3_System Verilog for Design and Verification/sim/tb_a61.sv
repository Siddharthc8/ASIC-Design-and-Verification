`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/13/2024 09:07:42 PM
// Design Name: 
// Module Name: tb_a61
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


module tb_a61();
// Assume generator class consists of three 8-bit data members (x,y, and z). 
// Write a code to generate 20 random values for all the data members at an interval of 20 ns.

class Generator;
    rand bit [7:0] x, y, z;
endclass
    
    Generator g;
    
    initial begin
        
        for (int i=0; i<20 ;i++) begin
            g = new();
            
            if (g.randomize()) 
                $display("%0d   Value of x: %0d, y: %0d, z: %0d", i+1, g.x, g.y, g.z);
            else
                $display("Assert Method: Randomization failed at %0t", $time); 
            #20;
            
        end 
        
    end
    
endmodule
