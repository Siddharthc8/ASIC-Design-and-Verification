`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2024 08:22:49 PM
// Design Name: 
// Module Name: rising_edge_detect_moore
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


module rising_edge_detect_moore
    (
        input  logic clk, reset,
        input  logic level,
        output logic tick
    );
    
    // FSM state type
    typedef enum {zero, edg, one} state_type;
    
    // Signal declaration
    state_type c_s, n_s;
    
    // State_register
    always_ff @(posedge clk, posedge reset)
    begin
        if(reset)
            c_s <= zero;
        else
            c_s <= n_s;
    end
    
    // Next state logic
    always_comb
    begin
        case(c_s)
            zero: 
                if(level)
                    n_s = edg;
                else
                    n_s = zero;
            edg:
                if(level)
                    n_s = one;
                else
                    n_s = zero;
            one:
                if(level)
                    n_s = one;
                else
                    n_s = zero;
            default: n_s = zero;
        endcase
    end
    
    assign tick = (c_s == edg);
endmodule
