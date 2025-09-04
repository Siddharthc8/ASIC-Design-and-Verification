`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2024 12:39:59 AM
// Design Name: 
// Module Name: tb_a54
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


module tb_a54();
//   Create a function that generate and return 32 values of multiple of 8 (0, 8, 16, 24, 32, 40 .... 248). 
//   Store this value in the local array of the testbench top and also print the value of each element of this array on the console.
    
    function automatic int gen(ref int a [32]);
    
        for(int i = 0;i<$size(a);i++) begin
            a[i] = i*8;
        end
        
        return a[32];
        
    endfunction
    
    int res [32];
    
    initial begin
        res[32] = gen(res);
        $display("Values of the array: %0p", res);
    end
    
endmodule
