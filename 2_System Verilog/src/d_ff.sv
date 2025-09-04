`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2024 12:44:08 AM
// Design Name: 
// Module Name: d_ff
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


module d_ff
    #(parameter n = 8)(
    input logic [n-1:0] d,
    input logic en,
    input logic reset,
    input logic clk,
    output logic [n-1:0] q
    );
    
    always @(posedge clk, posedge reset)
    begin
        if (reset)
            q <= 0;
        else if (en) 
            q <= d;
        else 
            q <= q;
    end
endmodule
