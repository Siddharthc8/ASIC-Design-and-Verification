`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2024 03:00:37 PM
// Design Name: 
// Module Name: decoder_2x4_en
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


module decoder_2x4_en
(
    input [1:0] w,
    input en,
    output reg [0:3] y
    );
    
    always @(w,en)
    begin
        y = 4'b0000;   // default value 
        
        if(en)
        begin
            case(w)
            0 : y = 4'b1000;
            1 : y = 4'b0100;
            2 : y = 4'b0010;
            3 : y = 4'b0001;
            default : y = 4'b0000;
            endcase
         end
        else
            y=4'b0000;
     end
endmodule
