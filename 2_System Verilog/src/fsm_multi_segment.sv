`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2024 07:49:29 PM
// Design Name: 
// Module Name: fsm_multi_segment
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


module fsm_multi_segment
    (
        input  logic clk,reset,
        input  logic a, b,
        output logic y0, y1 
    );
    
    typedef enum {s0, s1, s2} state_type;
    
    // Signal register
    state_type c_s, n_s;
    
    // State Register
    always_ff @(posedge clk, posedge reset)
    begin
        if(reset)
            c_s <= s0;
        else 
            c_s <= n_s;
    end
    
    // Next state logic 
    always_comb
    begin
        case(c_s)
            s0: if(a)
                    if(b)
                        n_s = s2;
                    else
                        n_s = s1;
                else 
                    n_s = s0;
            s1: if(a)
                    n_s = s0;
                    
                else
                    n_s = s1;
            s2: n_s = s0;
            default: n_s = s0;
        endcase   
    end
    
    // Mealy output
    assign y0 = (c_s = s0) & a & b;
    
    // Moore output 
    assign y1 = c_s == (s0 | s1);
endmodule
