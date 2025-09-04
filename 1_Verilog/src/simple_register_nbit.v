`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2024 03:20:16 PM
// Design Name: 
// Module Name: simple_register_nbit
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


module simple_register_nbit
    #(parameter n=4)
(
    input clk,
    input [n-1:0] I,
    output [n-1:0] Q
    );
    
    // Structural Method
//    generate
//        genvar i;
//        for(i=0;i<n;i=i+1)
//        begin: FF
//            D_FF_reset(
//            .clk(clk),
//            .D(I[i]),
//            .Q(Q[i]),
//            .clear_n(),
//            .reset_n()
//            );        
//        end
//    endgenerate


// Behavioral Method
    reg [n-1:0] Q_reg, Q_next;
    
    always @(posedge clk)
    begin
        Q_reg <= Q_next;
    end
    
    always @(I)
    begin
        Q_next = I;    
    end
    
    assign Q = Q_reg; 
endmodule








