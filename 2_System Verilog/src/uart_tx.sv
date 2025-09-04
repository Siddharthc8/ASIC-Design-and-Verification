`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2024 12:23:45 AM
// Design Name: 
// Module Name: uart_tx
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


module uart_tx
    #(parameter dbit = 8, sb_tick = 16)
    (
        input  logic clk,
        input  logic reset,
        input  logic tx_start,
        input  logic s_tick,
        input  logic [dbit-1 : 0] din,
        output logic tx_done_tick,
        output logic tx
    );
    
    // FSM state type
    typedef enum { idle, start, data, stop } state_type;
    
    state_type c_s, n_s;
    logic [3:0] s_reg, s_next;
    logic [2:0] n_reg, n_next;
    logic [7:0] b_reg, b_next;
    logic tx_reg, tx_next;
    
    // DSM state registers
    always_ff @(posedge clk, posedge reset)
        if(reset)
        begin
            c_s   <= idle;
            s_reg <= 0;
            n_reg <= 0;
            b_reg <= 0;
            tx_reg <= 1'b1;
        end
        else begin
            c_s   <= n_s;  
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
            tx_reg <= tx_next;
        end
        
        // Next state Logic
        always_comb
        begin
            tx_done_tick = 1'b0;
            n_s    = c_s;  
            s_next = s_reg;
            n_next = n_reg;
            b_next = b_reg;
            tx_next = tx_reg;
            
            case(c_s) 
            idle: begin
                tx_done_tick = 1'b0;
                if(tx_start) begin
                    n_s = start;
                    s_next = 0;
                    b_next = din;
                end
            end
            start: begin
                tx_next = 1'b0;
                if(s_tick)
                    if(s_reg==15) begin
                        n_s = data;
                        s_next = 0;
                        n_next = 0;    
                    end
                    else
                        s_next = s_reg + 1;
            end
            data: begin
                tx_next = b_reg[0];
                if(s_tick)                 
                    if(s_reg==15) begin        
                        s_next = 0;            
                        b_next = b_reg >> 1;
                        if(n_reg == (dbit-1))
                            n_s = stop;
                        else
                            n_next = n_reg +1;            
                    end                        
                    else                       
                        s_next = s_reg + 1;
            end 
            stop: begin
                tx_next = 1'b1;
                if(s_tick)
                    if(s_reg == (sb_tick-1)) begin
                        n_s = idle;
                        tx_done_tick = 1'b1;
                    end   
                    else
                        s_next = s_reg + 1;
            end
            endcase
        end
        
        // Output logic
        assign tx = tx_reg;
endmodule
