`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2024 12:42:12 AM
// Design Name: 
// Module Name: tb_a63
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


module tb_a63();
// For the Generator code mentioned in the Instruction tab, 
// expected values for variable a ranges from 0 to 8, variable b ranges from 0 to 5. 
// Also, add logic to store the number of times randomization failed. 
// Print values of variables during each iteration and error count after generating 20 random values for a and b. 
// Add Constraint Code and Testbench top code to  the Design
class Generator;
  
  rand bit [4:0] a;
  rand bit [5:0] b;
  
  constraint data_range { a inside { [0:8]};
                    b inside { [0:5]};
                  }
  
endclass
    
    Generator g;
    int fail_count = 0;
    
    initial begin
    
        g = new();
        
        for (int i=0; i<20 ;i++) begin
            if(!g.randomize()) begin
                fail_count += 1;
            end
            $display("%0d   Value of a: %0d, b: %0d, Fail count: %0d", i, g.a, g.b, fail_count);
   
        end
        
        $display("      Overall Fail Count: %0d", fail_count);
    end


endmodule
