`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2024 10:59:42 PM
// Design Name: 
// Module Name: mux_2x1_nbit
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


module mux_2x1_nbit
#(parameter n=3)
(
    input [n-1:0] w0,w1,
    input s,
    output reg [n-1:0] f
    );
    
//    assign f = s ? w1 : w0;
    
    always @(w0, w1, s) 
    begin
        f = s ? w1 : w0;
    end
endmodule




















