`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2024 12:53:04 PM
// Design Name: 
// Module Name: tb_decoder_2x4
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


module tb_decoder_2x4();
    
    reg [1:0] w;
    wire [0:3] y;
    
    decoder_2x4 uut(
        .w(w),
        .y(y)
    );
        
    initial begin
           w = 2'b00;
        #5 w = 2'b01;
        #5 w = 2'b10;
        #5 w = 2'b11;
        
    end    
    
initial #25 $finish;
endmodule
























