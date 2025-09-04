`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2024 09:59:36 AM
// Design Name: 
// Module Name: decoder_2x4
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


module decoder_2x4
(
    input [1:0] w,
    output reg [0:3] y
    );
    
    always @(w)
    begin
        y = 4'b0000;   // default value 
        
//        if( w == 2'b00)
//            y[0] = 1'b1;
//        else if (w == 2'b01)
//            y[1] = 1'b1;
//        else if (w == 2'b10)
//            y[2] = 1'b1;
//        else if (w == 2'b01)
//            y[3] = 1'b1;
//        else 
//            y = 'bx;

//        case(w)
//            0 : y = 4'b1000;
//            1 : y = 4'b0100;
//            2 : y = 4'b0010;
//            3 : y = 4'b0001;
//         endcase

//           Easier way to do

            y[w] = 1'b1;
     end
endmodule


















