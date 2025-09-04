`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2024 09:37:53 PM
// Design Name: 
// Module Name: practice
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


module mux_2x1(
    input a,
    input b,
    input s,
    output reg f
    );
    
   // typedef enum logic [1:0]{S0,S1,S2,S3} input_select;
    //parameter S1=00, S2=01, S3=10,S4=11;
    
    always @* begin
    
      case(s)
      
        0 : f = a;
        1 : f = b;
    endcase
    end
endmodule
