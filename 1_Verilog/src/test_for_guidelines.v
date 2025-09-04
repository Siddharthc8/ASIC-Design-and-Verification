`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2024 12:51:48 PM
// Design Name: 
// Module Name: test_for_guidelines
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


module test_for_guidelines(
    input a,b,c,
    input clk,
    output  reg f,g
    );
    
//    reg f_next, f_reg, g_next, g_reg;
    
//     always @(posedge clk)
//     begin
//        f_reg <= f_next;
//        g_reg <= g_next; 
//    end
    
//    // Next State Logic
    
//    always @(a,b,c,g_reg)
//    begin
//        f_next = a & ~g_reg;
//        g_next = b | c;
//    end
    
//    // Output Logic
//    assign  f = f_reg;
//    assign  g = g_reg;

//          OR

    always @(posedge clk)
    begin
        f <= a & ~g;
        g <= b | c;
    end
endmodule

