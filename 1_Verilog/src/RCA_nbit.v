`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2024 10:07:36 PM
// Design Name: 
// Module Name: RCA_nbit
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


module RCA_nbit
#(parameter integer n=4)
(
    input [n-1:0] x,y,
    input cin,
    output [n-1:0] sum,
    output cout
    );
    
    wire [n:0] c;
    
    assign c[0] = cin;
    assign cout = c[n];

    generate 
        genvar i;
        for(i=0; i<n; i= i+1)
        begin: stage
            FA FA(
                .x(x[i]),
                .y(y[i]),
                .cin(c[i]),
                .sum(sum[i]),
                .cout(c[i+1])
            );    
        end
    endgenerate
endmodule
