`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2024 08:23:22 PM
// Design Name: 
// Module Name: rising_edge_detect_mealy
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


module rising_edge_detect_mealy
    (
        input  logic clk, reset,
        input  logic level,
        output logic tick
    );
    
    // FSM state type
    typedef enum {zero, one} state_type;
    
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
        tick = 1'b0;
        n_s = zero;
        case(c_s)
            zero: 
                if(level)
                begin
                    tick = 1'b1;
                    n_s = one;
                end
                else
                    n_s = zero;
            one:
                if(level)
                begin
                    n_s = one;
                end
                else
                    n_s = zero;
            default: n_s = zero;
        endcase
    end
endmodule    
