`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 03:12:46 PM
// Design Name: 
// Module Name: mux_nx1
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


module mux_ix1_nbit
    #(parameter i = 16, n = 8)
    (
    input  logic [n-1:0] in [i-1:0],
    input  logic [$clog2(i)-1 : 0] sel,
    output logic out 
    );
    
    integer j;
    
    always_comb begin
        out = 'bx;
        for(j=0;j<i;j=j+1) begin
            if(j  == sel )
                out = in[j];
        end
    end
    
endmodule
