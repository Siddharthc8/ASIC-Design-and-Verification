`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 10:00:15 PM
// Design Name: 
// Module Name: tb_copying__arrays
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


module tb_copying_arrays();  // arrays should be of the same size and data type

    int arr1[5];     // SIZE and DATA TYPE  should be the same
    int arr2[5];
    
    initial begin
    
        for(int i = 0; i<$size(arr1);i++) begin
            arr1[i] = (5*i);
        end
        
        arr2 = arr1;                           // Array's contents are transferred
        
        $display("Array1 contents: %0p", arr1);
        $display("Array2 contents: %0p", arr2);
    end
    
endmodule
