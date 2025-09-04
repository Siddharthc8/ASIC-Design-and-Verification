`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2024 02:46:22 AM
// Design Name: 
// Module Name: compare_storage_elements
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


module compare_storage_elements(
    input D,
    input clk,
    output Qa, Qb, Qc
    );
    
    D_latch L0(
    .D(D),
    .clk(clk),
    .Q(Qa),
    .Q_b()
     );
     
    D_FF_pos FF0(
    .D(D),
    .clk(clk),
    .Q(Qb)
    );
    
    D_FF_neg FF1(
    .D(D),
    .clk(clk),
    .Q(Qc)
    );
endmodule
