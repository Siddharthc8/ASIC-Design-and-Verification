`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2024 11:57:03 PM
// Design Name: 
// Module Name: adder_subtractor
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


module adder_subtractor
    #(parameter n=4)
(
    input [n-1:0] x,y,
    input add_n,         // "_n" usually refers to True when low
    output [n-1:0] sum,
    output cout,
    output overflow
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
    
    assign overflow = (x[n - 1] & xor_y[n - 1] & ~sum[n - 1]) | (~x[n - 1] & ~xor_y[n - 1]& sum[n - 1]);
    
endmodule
