`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2024 04:56:21 PM
// Design Name: 
// Module Name: async_up_counter
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


module async_up_counter
    #(parameter n=4)(
    input clk,
    input reset_n,
    output [3:0] Q   
    );
    T_FF FF0(
            .clk(clk),
            .reset_n(reset_n),
            .T(1'b1),
            .Q(Q[0])
            );
            
    T_FF FF1(
            .clk(~Q[0]),
            .reset_n(reset_n),
            .T(1'b1),
            .Q(Q[1])
            );
    T_FF FF2(
            .clk(~Q[1]),
            .reset_n(reset_n),
            .T(1'b1),
            .Q(Q[2])
            );
    T_FF FF3(
            .clk(~Q[2]),
            .reset_n(reset_n),
            .T(1'b1),
            .Q(Q[3])
            );
 
//    generate 
//        genvar i;
//        for(i=0;i<n-1;i=i+1)
//        begin: FF
//            T_FF(
//            .clk(~Q[i]),
//            .reset_n(reset_n),
//            .T(1'b1),
//            .Q(Q[i+1])
//            );
//        end
//    endgenerate
                
        
endmodule
























