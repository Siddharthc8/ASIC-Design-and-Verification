`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2024 09:31:59 AM
// Design Name: 
// Module Name: univ_shift_reg
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


module univ_shift_reg
    #(parameter n=4) (
    input clk,reset_n,
    input MSB_in, LSB_in,
    input [n-1:0] in,
    input [1:0] mode,
    output [n-1:0] Q
    );
    
parameter nothing = 2'b00;
parameter shift_right = 2'b01;
parameter shift_left = 2'b10;
parameter load = 2'b11;

reg [n-1:0] Q_reg, Q_next;
    
    always @(posedge clk, negedge reset_n)
    begin
        if(!reset_n)
            Q_reg <= 0;
        else 
            Q_reg <= Q_next;
    end
    
    always @(*)
    begin
        Q_next = Q_reg;
        case(mode)
            nothing: Q_next = Q_reg;
            shift_right: Q_next = {MSB_in,Q_reg[n-1:1]};
            shift_left: Q_next = {Q_reg[n-2:0], LSB_in};
            load: Q_next = in;
            default: Q_next = Q_reg;
         endcase 
    end
    
    assign Q = Q_reg;
endmodule
