`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/11/2025 10:33:25 AM
// Design Name: 
// Module Name: ALU
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


module ALU
  (
    input [3:0] a,b,
    input [2:0] op,
    output reg [4:0] y
  
  );  
  
  always @(*)
    begin
      case(op)
        ///////////////arithmetic oper
        3'b000: y = a + b;
        3'b001: y = a - b;
        3'b010: y = a + 1;
        3'b011: y = b + 1;
        /////////////// logical oper
        3'b100: y = a & b;
        3'b101: y = a | b;
        3'b110: y = a ^ b;
        3'b111: y = ~a;
        
        default : y = 5'b00000;
      endcase
      
    end
endmodule
