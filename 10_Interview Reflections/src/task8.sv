`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/01/2025 06:50:28 AM
// Design Name: 
// Module Name: task8
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


module task8( input in, output out );
//    ( * ALLOW_COMBINATIONAL_LOOPS = "TRUE" * ) 
//    (* DONT_TOUCH = "TRUE" *)    
    wire w1, w2, w3, w4, w5;

    nand ( w1, in , w5 );
    not  #1 (w2, w1);
    not  (w3, w2);
    not  (w4, w3);
    not  (w5, w4);
    
    assign out = w5;
    
endmodule
