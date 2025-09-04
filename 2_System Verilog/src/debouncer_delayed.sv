`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/14/2024 06:14:04 PM
// Design Name: 
// Module Name: debouncer_delayed
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


module debouncer_delayed(
    input  logic sw,          // Switch
    input  logic reset,
    input  logic clk,
    output logic db          // Delayed_debounced output
);
    
    // 10ms m_tick genrator
    // Assuming clk is 100MHz (clk = 10ns)
    // 10ms / 10ns is 10e-3 / 10e-9 which is 1_000_000
    logic m_tick;
    mod_m_counter #(.m(1_000_000)) ticker (
        .clk(clk),
        .reset(reset),
        .q(),
        .max_tick(m_tick)
    );
    
    // There is a bug somewhere if you click the switch continuously fast enough the output disappears
    typedef enum {zero, wait_11, wait_12, wait_13, one, wait_01, wait_02, wait_03} state_type;
    
    // Signal decalaration
    state_type c_s, n_s;
    
    // State register
    always_ff @(posedge clk, posedge reset)
    begin
        if(reset)
            c_s <= zero;
        else
            c_s <= n_s;
    end
    
    always_comb 
    begin
        case(c_s)
        zero:
            if(sw)
                    n_s = wait_11;
                else
                    n_s = zero;
                    
        wait_11:
            if(sw)
                if(m_tick)
                    n_s = wait_12;
                else
                    n_s = wait_11;
            else
                n_s = zero;
                
        wait_12:
            if(sw)
                if(m_tick)
                    n_s = wait_13;
                else
                    n_s = wait_12;
            else
                n_s = zero;
                
        wait_13:
            if(sw)
                if(m_tick)
                    n_s = one;
                else
                    n_s = wait_13;
            else
                n_s = zero;
                
        one:
            if(~sw)
                    n_s = wait_01;
                else
                    n_s = one;
                    
        wait_01:
            if(~sw)
                if(~m_tick)
                    n_s = wait_01;
                else
                    n_s = wait_02;
            else
                n_s = zero;
                
        wait_02:
            if(~sw)
                if(~m_tick)
                    n_s = wait_02;
                else
                    n_s = wait_03;
            else
                n_s = one;
                
        wait_03:
            if(~sw)
                if(~m_tick)
                    n_s = wait_03;
                else
                    n_s = zero;
            else
                n_s = one;
        
        default: n_s = zero;
            
        endcase
    end
    
    // Moore output
    assign db = ( (c_s == one) || (c_s == wait_01) || 
                  (c_s == wait_02) || (c_s == wait_03) );
endmodule
