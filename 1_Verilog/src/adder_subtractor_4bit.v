`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2024 11:49:41 PM
// Design Name: 
// Module Name: adder_subtractor_4bit
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


module adder_subtractor_4bit(
    input [3:0] x,y,
    input add_n,         // "_n" usually refers to True when low
    output [3:0] sum,
    output cout
    );
    
    wire [3:0] xor_y;
    assign xor_y[3:0] = {y[3] ^ add_n, y[2] ^ add_n, y[1] ^ add_n, y[0] ^ add_n};
    //assign xor_y[3:0] = y[3:0] ^ add_n;
    
    RCA_nbit #(.n(4)) A0(
        .x(x),
        .y(xor_y),
        .cin(add_n),
        .sum(sum),
        .cout(cout)
    );
    
endmodule
