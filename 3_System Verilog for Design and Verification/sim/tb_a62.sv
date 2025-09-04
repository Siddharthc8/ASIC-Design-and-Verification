`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/13/2024 10:33:37 PM
// Design Name: 
// Module Name: tb_a62
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


module tb_a62();
// Assume generator class consists of three 8-bit data members (x,y, and z). 
// Write a code to generate 20 random values for all the data members at an interval of 20 ns. 
// Random values for all data members should range from 0 to 50.
class Generator;

    rand bit [7:0] x, y, z; 
    
    constraint data {  x inside { [ 0:50 ] };
                       y inside { [ 0:50 ] };
                       z inside { [ 0:50 ] };
                    }
                    
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
