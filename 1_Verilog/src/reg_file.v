`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2024 12:21:22 PM
// Design Name: 
// Module Name: reg_file
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


module reg_file
    #(parameter addr_width = 7, data_width = 8)(
    input clk,
    input we,
    input [addr_width-1:0] address_w, address_r,
    input [data_width-1:0] data_w,
    output [data_width-1:0] data_r
    );
    
    reg [data_width-1:0] memory [0:2**addr_width-1];
    
    always @(posedge clk)
    begin
        if(we)
            memory[address_w] <= data_w;    
    end
    
    assign data_r = memory[address_r];
endmodule
