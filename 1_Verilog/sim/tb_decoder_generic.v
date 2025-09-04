`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2024 04:06:55 PM
// Design Name: 
// Module Name: tb_decoder_generic
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


module tb_decoder_generic();

// Define local reg and wire identifiers
    parameter n=4;
    reg [n-1:0] w;
    reg en;
    wire [0:(2**n)-1] y;
    integer i;

// Instantiate the uut
    decoder_generic #(.n(n)) uut(
        .w(w),
        .en(en),
        .y(y)
    );

    initial begin
        for(i=0;i<2**n;i=i+1)
        begin
            w=i;
            en=1'b1;
            #5;
            $display("w=%b, en=%b, y=%b", w, en, y);
        end
        
        for(i=0;i<2**n;i=i+1)
        begin
            w=i;  
            en=1'b0;
            #5;
            $display("w=%b, en=%b, y=%b", w, en, y);
        end
    end
    initial #150 $finish;
endmodule
















