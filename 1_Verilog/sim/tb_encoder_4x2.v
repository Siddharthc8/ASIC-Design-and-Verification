`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2024 08:08:37 PM
// Design Name: 
// Module Name: tb_encoder_4x2
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


module tb_encoder_4x2();

    reg [3:0] w;
    wire [1:0] y;
    integer i;
    
    encoder_4x2 uut(
        .w(w),
        .y(y)
    );
    
    initial begin
        w=0;
        for (i=0;i<32;i=i+1)
        begin
            w = i;
            #5;
        end
    end
    initial #100 $finish;
    
endmodule
