`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 10:29:55 PM
// Design Name: 
// Module Name: tb_dynamic_array
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


module tb_dynamic_array();
    
    int arr[];              // Dynamic size array
    int farr[30];           // Fixed size array
    
    initial begin        
        arr  = new[5];       // To specify the size of a dynamic array "new[size]" method is used 
        for(int i = 0; i<$size(arr); i++) begin
            arr[i] = 5 * i;
        end
        
        $display("arr: %0p, size: %0d", arr, $size(arr));
        
        arr = new[4](arr);    // If the destination array is small, truncates the values accordingly
        $display("arr: %0p, size: %0d", arr, $size(arr));
        
        arr = new[30](arr);    // The "(arr)" actually copies the previous values to this new array
        $display("arr: %0p, size: %0d", arr, $size(arr));
        
        /////   Trying to copy the contents of a dynamic array to a static array   /////
        farr = arr;       // can be done as the dynamic array can now hold upto 30 places
        $display("farr: %0p, size: %0d", farr, $size(farr));
        
        arr = new[30];   // This is like calling a new array with all the previous contents erased/delted
        $display("arr: %0p, size: %0d", arr, $size(arr));
        
        arr.delete();       // To delete an array
        $display("arr: %0p, size: %0d", arr, $size(arr));
        
        arr[1] = 2;         // Throws an error as we are trying to write in an empty array
        $display("arr: %0p, size: %0d", arr, $size(arr));   // Returns size as 0
        
        #10;
        $finish;
    end


endmodule
