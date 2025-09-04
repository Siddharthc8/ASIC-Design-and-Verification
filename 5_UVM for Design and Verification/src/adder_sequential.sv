`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2024 07:32:56 AM
// Design Name: 
// Module Name: adder_sequential
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


module adder_sequential(
    input clk,
    input rst,
    input [3:0] a,
    input [3:0] b,
    output reg [4:0] y
    );
    
    always_ff @(posedge clk) 
    begin
        if(rst)
            y <= 0;
        else
            y <= a + b;
    end
    
endmodule

interface add_if();
    
    logic clk;
    logic rst;
    logic [3:0] a;
    logic [3:0] b;
    logic [4:0] y;

endinterface
