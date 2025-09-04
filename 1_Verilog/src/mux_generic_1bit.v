`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2024 12:29:46 AM
// Design Name: 
// Module Name: mux_generic_1bit
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


module mux_generic_1bit
#(parameter n=16)
(
    input [n-1:0] w,
    input [$clog2(n)-1:0] s,
    output reg f 
    );
    
    integer i;
    
    always @(w,s)
    begin
        f = 'bx;
        for(i = 0; i < n; i = i + 1)
            if (i == s)
                f = w[i];        
    end
endmodule















