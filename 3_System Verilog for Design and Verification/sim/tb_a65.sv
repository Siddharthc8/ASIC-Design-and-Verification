`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2024 06:58:01 PM
// Design Name: 
// Module Name: tb_a65
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


module tb_a65();
// Generate values between 0 to 7 for addr signal when wr is high and values between 8 to 15 when wr is low. 
// Generator code is mentioned in the Instruction tab. 
// Verify your code for 20 iterations by sending values of both wr and addr on a console.
    
    
class Generator;

    rand bit [3:0] addr;
    rand bit wr;
    
    constraint addr_range { 
        if ( wr == 1) {
            addr inside {[ 0:7 ]};
        }
        else {
            addr inside {[ 8:15 ]};
        }
    }

endclass


    Generator g;
    
    initial begin
        
        g = new();
        
        for(int i = 0; i<20; i++) begin
            if(g.randomize())
                $display(" wr: %0d and add: %0d ", g.wr, g.addr);
            else
                $display("Randomization Failed");
        
        end
    
    end


endmodule
