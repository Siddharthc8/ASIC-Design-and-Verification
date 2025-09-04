`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2024 10:41:10 PM
// Design Name: 
// Module Name: multiadders
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


module multiadders(
    input [15:0] a,b,
    input [33:0] x,y,
    input cin_ab, cin_xy,
    output [15:0] sum_ab,
    output [33:0] sum_xy,
    output cout_ab, cout_xy
    );
    
    RCA_nbit #(.n(16)) adder_16bit(
    .x(a),
    .y(b),
    .cin(cin_ab),
    .sum(sum_ab),
    .cout(cout_ab)
    );
    
    RCA_nbit #(.n(34)) adder_34bit(
    .x(x),
    .y(y),
    .cin(cin_xy),
    .sum(sum_xy),
    .cout(cout_xy)
);

endmodule





















