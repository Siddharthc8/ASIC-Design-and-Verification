`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2024 09:38:41 PM
// Design Name: 
// Module Name: dummy
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


module dummy(
    input [7:0] a,
    input [2:0] amt,
    output [7:0] y
    );
    
    wire [7:0] s0, s1;
    
    assign s0 = amt[0] ? {a[0], a[7:1]} : a;
    
    assign s1 = amt[0] ? {s0[1:0], s0[7:2]} : s0;
    
    assign y = amt[0] ? {s1[3:0], s1[7:4]} : s1;
    
    
endmodule
