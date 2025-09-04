`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2024 08:58:36 PM
// Design Name: 
// Module Name: priority_encoder_generic
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


module priority_encoder_generic
#(parameter n=4)
(
    input [n-1:0] w,
    output z,
    output reg [$clog2(n)-1:0] y 
        );
        
        integer i;  
        assign z = |w;
        
        always @(w)
        begin
            y = 'bx;
            for (i=0;i<n;i=i+1)
            begin
                if (w[i])
                    y=i;            
            end
        end
endmodule
