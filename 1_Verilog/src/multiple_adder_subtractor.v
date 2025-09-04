`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2024 12:55:30 AM
// Design Name: 
// Module Name: multiple_adder_subtractor
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


module multiple_adder_subtractor(
    input [15:0] a,b,
    input add_n_ab, add_n_xy,
    input [31:0] x,y,
    output [15:0] sum_ab,
    output [31:0] sum_xy,
    output cout_ab, cout_xy
    );

    adder_subtractor_nbit #(.n(16)) add_sub_16bit(
        .x(a),
        .y(b),
        .add_n(add_n_ab),
        .sum(sum_ab),
        .cout(cout_ab)
        );  
        
    adder_subtractor_nbit #(.n(32)) add_sub_32bit(
        .x(x),
        .y(y),
        .add_n(add_n_xy),
        .sum(sum_xy),
        .cout(cout_xy)
        );   
        
endmodule
