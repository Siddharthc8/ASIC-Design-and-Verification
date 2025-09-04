`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2024 05:59:14 PM
// Design Name: 
// Module Name: debouncer_delayed_fsm
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


module debouncer_delayed_fsm(
    input clk, reset_n,
    input noisy, timer_done,
    output timer_reset, debounced
    );
    
    reg [1:0] c_s, n_s;
    parameter s0 = 0, s1 = 1, s2 = 2, s3 = 3;
    
    always @(posedge clk, negedge reset_n)
    begin
        if(!reset_n)
            c_s <= s0;
        else
            c_s <= n_s;
    end 
    
    always @(*)
    begin
        n_s = c_s;
            case(c_s)
                s0 : if (~noisy) 
                        n_s = s0;
                     else if (noisy)
                        n_s = s1;
                s1 : if (~noisy) 
                        n_s = s0;
                     else if (noisy & ~timer_done)
                        n_s = s1;
                     else if (noisy & timer_done)
                        n_s = s2;
                s2 : if (~noisy)
                        n_s = s3;
                     else if (noisy)
                        n_s = s2;
                s3 : if (noisy)
                        n_s = s2;
                     else if (~noisy & ~timer_done)
                        n_s = s3;
                     else if (~noisy & timer_done)
                        n_s = s0;
                                                
                default: n_s = c_s;
                endcase
    end
    
    assign timer_reset = (c_s == s0) || (c_s ==  s2);
    assign debounced = (c_s == s2) || (c_s == s3);
    
endmodule
