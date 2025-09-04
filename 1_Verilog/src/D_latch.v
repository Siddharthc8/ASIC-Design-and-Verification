`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2024 02:04:31 AM
// Design Name: 
// Module Name: D_latch
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


module D_latch(
    input D,
    input clk,
    output reg Q,
    output Q_b
    );
    
    assign Q_b = ~Q;
    
    always@(D,clk)
    begin
            Q = Q;
            if(clk)
                Q = D;
            else 
                Q = Q;
     end
endmodule
