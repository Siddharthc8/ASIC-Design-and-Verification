`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 12:08:52 AM
// Design Name: 
// Module Name: tb_a33
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


module tb_a33();
// Create two arrays of reg type capable of storing 15 elements. 
// Use $urandom function to add 15 values to the array. 
// Print the value of all the elements of the array on a single line.

    reg arr1[];
    reg arr2[];
    int i = 0;
    
    initial begin
        arr1 = new[15];        // Just practicing this method
        arr2 = new[15];
        
        for(int i=0;i<$size(arr1);i++) begin
            arr1[i] = $urandom();
            arr2[i] = $urandom();
        end
        
        $write("Arr1 values: %0p", arr1);    // $write prints all the values on the same line
        $display("");
        $write("Arr2 values: %0p", arr2);
        $display("");
        
        #10 $finish;
    end

endmodule
