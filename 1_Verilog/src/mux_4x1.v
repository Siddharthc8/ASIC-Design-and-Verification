`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2024 12:44:12 AM
// Design Name: 
// Module Name: mux_4x1
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


module mux_4x1(
    input x0,x1,x2,x3,s0,s1,
    output f
    );
    
    wire w1,w2;
    
   // typedef enum logic [1:0]{S0,S1,S2,S3} input_select;
    //parameter S1=00, S2=01, S3=10,S4=11;
    
    mux_2x1 M0 (x0,x1,s1,w1); //   mux_2x1 M0(.a(x0), .b(x1), .s(s1), .f(w1));
    mux_2x1 M1 (x2,x3,s1,w2); //   mux_2x1 M1(.a(x2), .b(x3), .s(s1), .f(w2));
    mux_2x1 M2 (w1,w2,s0,f);  //   mux_2x1 M2(.a(w1), .b(w2), .s(s0), .f(f));

    
endmodule
