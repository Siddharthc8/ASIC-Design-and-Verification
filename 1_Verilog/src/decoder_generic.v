`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2024 03:30:00 PM
// Design Name: 
// Module Name: decoder_generic
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


module decoder_generic
#(parameter n=3)
(
    input [n-1:0] w,
    input en,
    output reg [0: 2**n - 1] y             // 2 power n -1
    );
    
    always @(en, w) begin
        y = 'b0;
        
        if(en)
            y[w] = 1'b1;
        else
            y = 'b0;    
    end
 
endmodule
