`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 07:31:29 PM
// Design Name: 
// Module Name: tb_a32
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


module tb_a32();

////  Create an array capable of storing 10 elements of an unsigned integer. 
///   Initialize all the 10 elements to a value equal to the square of the index of that element. 
///   for e.g. first element has index no. 0 so initialize it to 0, 
///   the second element has index no. 1 so initialize it to 1, 
///   the third element has index no. 2 so initialize it to 4, and so on. 
///   Verify the code by sending values of all the elements on Console.


    int arr[10] = '{ default : 0};   // Remember these are signed data types
    
    initial begin
        for(int i=0; i<$size(arr); i++) begin
            arr[i] = i*i;  
        end
    end
    
    initial begin
        #10;
        $display("The array elements of arr are: %0p", arr);
    end
endmodule
