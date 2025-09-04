`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2024 06:21:14 PM
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
    input clk, reset_n,
    input noisy,
    output debounced
    );
    
    wire timer_done, timer_reset;
    
    debouncer_delayed_fsm FSM0 (
        .clk(clk),
        .reset_n(reset_n),
        .noisy(noisy),
        .timer_done(timer_done),
        .timer_reset(timer_reset),
        .debounced(debounced)
    );
    
    // Timer for 20ms
    timer_parameter #(.saturation_value(1_999_999)) T0 (
        .clk(clk),
        .reset_n(~timer_reset),
        .enable(~timer_reset),
        .saturation(timer_done)
    );
endmodule
