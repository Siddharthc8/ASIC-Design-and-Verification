`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2024 03:12:33 PM
// Design Name: 
// Module Name: tb_decoder_2x4_en
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


module tb_decoder_2x4_en();
    
    reg [1:0] w;
    reg en;
    wire [0:3] y;
    
    decoder_2x4_en uut(
        .w(w),
        .y(y),
        .en(en)
    );
        
    initial begin
    
           en = 1'b0;
           
           w = 2'b00;
        #5 w = 2'b01;
        #5 w = 2'b10;
        #5 w = 2'b11;
        
        #5  en = 1'b1;
        
           w = 2'b00;
        #5 w = 2'b01;
        #5 w = 2'b10;
        #5 w = 2'b11;
        
    end    
    
initial #50 $finish;
endmodule
