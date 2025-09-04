`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 06:11:23 PM
// Design Name: 
// Module Name: fa
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


module ha(
    input a, b,
    output s, c
    );
    
    assign s = a ^ b;
    assign c = a & b;
    
endmodule


module fa(
    input a, b, cin,
    output sout, cout
    );
    
    ha h1(a, b, w1, w2);
    ha h2(cin, w1, sout, w3);
    
    assign cout = w2 | w3;
    
endmodule
