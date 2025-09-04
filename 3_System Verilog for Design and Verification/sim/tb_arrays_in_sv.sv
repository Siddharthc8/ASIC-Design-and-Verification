`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 06:35:06 PM
// Design Name: 
// Module Name: arrays_in_sv
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


module tb_arrays_in_sv();
    
    int arr0 [2];   // The contents are set according to the datatype declared either 0 for 2-bit data types and x for 4-bit data types
    bit arr1 [8];   // In SV array can be defined just like array[8] unlike array[7:0] in verilog
    bit arr2 [] = {1,0,1,1};  // This sets the size of the array to 4 and use curly braces to put data in an array
    
    
    int arr3 [] = '{ 1, 2, 3 , 4 };   // Decalared in int datatype because of the values 1, 2, 3
    bit arr4 [6] = '{ 6{1} };        // Must specify the size of the array for this
    bit arr5 [8] = '{ default:0 };  // Leaving it empty does not cause any problem but won't be able to display the contents
    
    initial begin
        $display("Size of arr1: %0d", $size(arr1));     // $size(array) displays the size of the array
        $display("Size of arr2: %0d", $size(arr2));
        
        $display("The value of the first element of array1: %0d", arr1[0]);    // To access the first element of the array
        arr1[1] = 1;
        $display("The value of the second element of array1: %0d", arr1[1]);
        
        $display("The value of all the elements on an array3: %0p", arr3);
        
        $display("The value of all the elements on an array4: %0p", arr4);
        
        arr5 [1] = 1;
        $display("The value of all the elements on an array5: %0p", arr5);  // The notation to represent a whole array is "%0p"
        $display("The value of the second element in arr5: %0d", arr5[1]);
        
        #10;
        $finish();
    end
    
    
endmodule
