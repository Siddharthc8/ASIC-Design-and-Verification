`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2025 09:39:39 PM
// Design Name: 
// Module Name: tb_mixed_packed_and_unpacked_array
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


module tb_mixed_packed_and_unpacked_array();
    
    // Mixed arrays can be decalred using typedef 
    typedef logic [7:0] mem_t [0:255];
    mem_t mem;
    
    bit [3:0][5:1]v1[7:0];
    
    // v1 = 1D array of 2D packed arrays
    // v1[3] = 2D packed array[3:0][5:1]
    // v1[3][2] = 1D packed array[5:1]
    // v1[3][2][1] = scalar bit
    
    
    
endmodule
