`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2025 09:53:58 PM
// Design Name: 
// Module Name: tb_array_system_functions
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


module tb_array_system_functions();

    //     Multidimension Queries
    
    // $dimensions          : Numberof dimensions in the array
    // $unpacked_dimensions : Number of unpacked dimensionsin array
    
    
    //      Single Dimension Queries
    
    // $left      :  Left bound      // For eg [7:0] left buund is 7 and right bound is 0
    // $right     :  Right bound
    // $low       :  Lowest bound
    // $high      :  Highest bound
    // $increment :  1 if $left >= $right, else -1
    // $size      :  Number of elements
    
    typedef logic [7:0] mem_t [1:1024];   // un_packed dimension is the first dimension
    mem_t mem;
    
    initial begin
    
         $display($dimensions(mem)); // 2
         $display($unpacked_dimensions(mem_t));// 1
         $display($left(mem)); // 1
         $display($high(mem_t,2)); // 7
         $display($increment(mem)); //-1
     
     end
endmodule
