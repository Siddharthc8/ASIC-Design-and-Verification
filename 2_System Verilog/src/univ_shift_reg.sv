`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2024 11:28:32 AM
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
    #(parameter n= 8)
    (
        input logic clk, reset,   
        input logic [1:0] ctrl,
        input logic [n-1:0] d,
        output logic [n-1:0] q
    );
    
    // Signal decalaration
    logic [n-1:0] c_s, n_s;
    
    always_ff @(posedge clk, posedge reset)
    begin
        if (reset)
            c_s <= 0;
        else 
            c_s <= n_s;
    end
    
    always_comb 
    begin
        case(ctrl)
        2'b00: n_s = c_s;
        2'b01: n_s = {c_s[n-2:0], d[0]};   // left shift
        2'b10: n_s = {d[n-1], c_s[n-1:1]}; // Right shift
        2'b11: n_s = d;
        default: n_s = c_s;
        endcase
    end
    
    assign q = c_s;
endmodule
