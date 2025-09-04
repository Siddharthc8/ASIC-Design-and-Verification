`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2024 07:47:37 PM
// Design Name: 
// Module Name: adder_combinational
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


module adder_combinational(
    input [3:0] a,
    input [3:0] b,
    output [4:0] y
    );
    
    assign y = a + b;
    
endmodule

interface add_if();
    logic [3:0] a;
    logic [3:0] b;
    logic [4:0] y;
endinterface
