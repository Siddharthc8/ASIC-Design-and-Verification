`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2024 10:11:06 PM
// Design Name: 
// Module Name: coding_guidelines
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


module coding_guidelines(
    input a,b,c,
    output reg x 
    );
    
    always @(a,b,c) 
    begin
        x <= a;
        x <= x ^ b;
        x <= x | c;
        // Basically follows (a^b) | c;
    end
endmodule
