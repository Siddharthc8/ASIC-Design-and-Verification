`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2025 01:55:20 PM
// Design Name: 
// Module Name: tb_logic_limitations
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


module tb_logic_limitations();

    module test;
    
        logic in1,in2, in3;
        logic op;
        
        mone u1(op, in1, in2);      // WRONG because "op" is declared as logic and cannot be assigned to the multiple modules output
        mtwo u2(op, in1, in3);      // WRONG because "op" is declared as logic
        
    endmodule
    
    module test2;
    
        logic in1,in2, in3;
        wire op;                   // CORRECT as it is of wire type
        
        mone u1(op, in1, in2);      // CORRECT because "op" is declared as wire
        mtwo u2(op, in1, in3);      // CORRECT because "op" is declared as wire
        
    endmodule

endmodule
