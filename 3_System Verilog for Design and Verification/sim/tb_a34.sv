`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 12:24:54 AM
// Design Name: 
// Module Name: tb_a34
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


module tb_a34();
// Create a dynamic array capable of storing 7 elements. 
// add a value of multiple of 7 starting from 7 in the array (7, 14, 21 ....49). 
// After 20 nsec Update the size of the dynamic array to 20. 
// Keep existing values of the array as it is and update the rest 13 elements to a multiple of 5 starting from 5. 
// Print Value of the dynamic array after updating all the elements.
// Expected result : 7, 14, 21, 28 ..... 49, 5, 10, 15 ..... 65 


    int arr1[];
    int old_size;
    
    initial begin
        
        arr1 = new[7];
        old_size = $size(arr1);
        for(int i = 0; i<$size(arr1); i++) begin
            arr1[i] = (i+1) * 7;
        end
        
        #20;
        arr1 = new[20](arr1);
        
        for(int i = old_size; i<$size(arr1); i++) begin
            arr1[i] = (i-old_size+1) * 5;
        end
        
        $display("The array elements of arr1 are: %0p", arr1);
        
        #20 $finish;
        
    end
endmodule
