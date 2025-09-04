`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 05:31:16 PM
// Design Name: 
// Module Name: mux_2x1
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
    input  logic a,b,c,d,
    input  logic [1:0] sel,
    output logic y
    );
    
    reg temp;
    
    always @(*) begin
        if(sel ==2'b00)
            y = a;
        else if(sel ==2'b01)
            y = b;
        else if(sel ==2'b10)
            y = c;
        else
            y = d;
    end
endmodule
