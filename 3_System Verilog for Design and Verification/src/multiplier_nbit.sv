`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2024 11:19:16 PM
// Design Name: 
// Module Name: multiplier_nbit
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


module multiplier_nbit
    #(parameter n = 4)
    (
        input  logic clk, rst,
        input  logic [n-1:0] a,
        input  logic [n-1:0] b,
        output logic [2*n-1:0] res
    );
    
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            res <= 0;
        end
        else begin
            res <= a * b;
        end
    end
    
endmodule
