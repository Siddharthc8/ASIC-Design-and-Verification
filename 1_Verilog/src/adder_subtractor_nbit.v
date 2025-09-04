`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2024 12:47:38 AM
// Design Name: 
// Module Name: adder_subtractor_nbit
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


module adder_subtractor_nbit
    #(parameter n=4)
(
    input [n-1:0] x,y,
    input add_n,         // "_n" usually refers to True when low
    output [n-1:0] sum,
    output cout
    );
    
    wire [n-1:0] xor_y;
    
    generate
    genvar i;
        for(i=0;i<n;i=i+1)
        begin: y_bits
            assign xor_y[i] = y[i] ^ add_n;  
        end    
    endgenerate         
    
    RCA_nbit #(.n(n)) A0(
        .x(x),
        .y(xor_y),
        .cin(add_n),
        .sum(sum),
        .cout(cout)
    );
    
endmodule
