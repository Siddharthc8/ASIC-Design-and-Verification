`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 09:00:31 AM
// Design Name: 
// Module Name: multi_decade_counter
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


module multi_decade_counter(
    input clk,
    input reset_n,
    input enable,
    output saturation,
    output [3:0] ones, tens, hundreds
    );
    
    wire saturation0, saturation1, saturation2;
    wire a0, a1, a2;
    
    BCD_counter D0(
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .saturation(saturation0),
        .Q(ones)
    );
    assign a0 = enable & saturation0;
    
    BCD_counter D1(
        .clk(clk),
        .reset_n(reset_n),
        .enable(a0),
        .saturation(saturation1),
        .Q(tens)
    );
    assign a1 = a0 & saturation1;
    
    BCD_counter D2(
        .clk(clk),
        .reset_n(reset_n),
        .enable(a1),
        .saturation(saturation2),
        .Q(hundreds)
    );
    assign a2 = a1 & saturation2;
    
    assign saturation = a2;
endmodule
