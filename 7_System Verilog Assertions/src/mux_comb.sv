`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2024 11:47:07 AM
// Design Name: 
// Module Name: mux_comb
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


module mux_comb(
    input logic a, b, c, d,
    input logic [1:0] sel,
    output logic  y
    );
    
    always @(*) begin
        
        case(sel)
            2'b00: y = a;
            2'b01: y = b;
            2'b10: y = c;
            2'b11: y = d;
        endcase
        
    end
    
    
    always @(*)
    begin
        
        case(sel)
            2'b00: y_equals_a : assert (y == a) else $error("y is not equal to a at %0t", $time);
            2'b01: y_equals_b : assert (y == b) else $error("y is not equal to b at %0t", $time);
            2'b10: y_equals_c : assert (y == c) else $error("y is not equal to c at %0t", $time);
            2'b11: y_equals_d : assert (y == d) else $error("y is not equal to d at %0t", $time);
        endcase
        
    end
endmodule
