`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2024 10:56:18 PM
// Design Name: 
// Module Name: mux_2x1
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


module mux_2x1(
    input logic x0,
    input logic x1,
    input logic s,
    output logic f
    );
    
    logic p0, p1;
    
    assign f = p0 | p1;
    assign p0 = x0 & ~s;
    assign p1 = s & x1;
endmodule
