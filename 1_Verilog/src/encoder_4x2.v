`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2024 07:55:52 PM
// Design Name: 
// Module Name: encoder_4x2
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


module encoder_4x2(
    input [3:0] w,
    output reg [1:0] y
    );
    
    always @(w)
    begin 
        y = 2'bxx;
        case (w)
            4'b0001 : y = 0; 
            4'b0010 : y = 1;
            4'b0100 : y = 2;
            4'b1000 : y = 3;   
            default : y = 2'bxx;
        endcase
    end
endmodule





















