`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2024 03:44:28 PM
// Design Name: 
// Module Name: shift_register
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


module shift_register
    #(parameter n=4)
(
    input clk,
    input in,
    output [n-1:0] Q,
    output out
);

// Behavioral Method
    reg [n-1:0] Q_reg, Q_next;
    
    always @(posedge clk)
    begin
        Q_reg <= Q_next;
    end
    
    always @(in,Q_reg)
    begin
    // Right shift
        Q_next = {in,Q_reg[n-1:1]};
        
    // Left shift
//        Q_next = {Q_reg[n-2:0], in};
    end
    
    // Right shift
  assign out = Q_reg[0];  
  
    // Left shift
//    assign out = Q_reg[n-1];

    assign Q = Q_reg;
 endmodule
