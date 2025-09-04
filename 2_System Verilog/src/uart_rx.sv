`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2024 08:36:42 PM
// Design Name: 
// Module Name: uart_rx
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


module uart_rx
    #(parameter dbit = 8, sb_tick = 16)
    (
        input  logic clk,
        input  logic reset,
        input  logic rx,
        input  logic s_tick,
        output logic rx_done_tick,
        output logic [dbit-1 : 0] dout
    );
    
    // FSM state type
    typedef enum { idle, start, data, stop } state_type;
    
    state_type c_s, n_s;
    logic [3:0] s_reg, s_next;
    logic [2:0] n_reg, n_next;
    logic [7:0] b_reg, b_next;
    
    
    // DSM state registers
    always_ff @(posedge clk, posedge reset)
        if(reset)
        begin
            c_s   <= idle;
            s_reg <= 0;
            n_reg <= 0;
            b_reg <= 0;
        end
        else begin
            c_s   <= n_s;  
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
        end
        
        // FSM Next state logic
        always_comb
        begin
            // Defaults
            rx_done_tick = 0;
            n_s    = c_s;  
            s_next = s_reg;
            n_next = n_reg;
            b_next = b_reg;
            
            case(c_s) 
            idle:
                if(~rx) begin
                    n_s = start;
                    s_next = 0;
                end
            start:
                if(s_tick)
                    if(s_reg==7) begin
                        n_s = data;
                        s_next = 0;
                        n_next = 0;    
                    end
                    else
                        s_next = s_reg + 1;
            data:
                if(s_tick)                 
                    if(s_reg==15) begin        
                        s_next = 0;            
                        b_next = {rx, b_reg[7:1]};
                        if(n_reg == (dbit-1))
                            n_s = stop;
                        else
                            n_next = n_reg +1;            
                    end                        
                    else                       
                        s_next = s_reg + 1; 
            stop:
                if(s_tick)
                    if(s_reg == (sb_tick-1)) begin
                        n_s = idle;
                        rx_done_tick = 1'b1;
                    end   
                    else
                        s_next = s_reg + 1;
            endcase
        end
        
        // Output Logic
        assign dout = b_reg;
endmodule
















