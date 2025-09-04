`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2024 03:18:47 PM
// Design Name: 
// Module Name: T_FF
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


module T_FF(
    input clk,
    input reset_n,
    input T,
    output Q
    );
    localparam C2Q_DELAY = 2; // For simulation only 
    
    reg Q_reg; 
    wire Q_next;
    
    always @(posedge clk, negedge reset_n)
    begin
        if (!reset_n)
            Q_reg <= 1'b0;
        else
            #C2Q_DELAY Q_reg <= Q_next;
    end
    
    assign Q_next = T ? ~Q_reg : Q_reg;
    
    assign Q = Q_reg;
endmodule






















