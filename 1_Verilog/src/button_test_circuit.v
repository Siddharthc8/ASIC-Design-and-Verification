`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2024 12:25:43 PM
// Design Name: 
// Module Name: button_test_circuit
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


module button_test_circuit 
    #(parameter bits = 4)(
    input clk, reset_n, 
    input button_in,                      // Nothing but "noisy"
    //output [7:0] AN,
    //output [6:0] sseg,
    //output DP,
    output [bits-1:0] Noisy_count, Debounced_count
    );
    
    wire debounced_tick;
    wire [3:0] Q_debounced;
    
    debouncer_button DEBOUNCED_BUTTON (
        .clk(clk),
        .reset_n(reset_n),
        .noisy(button_in),
        .debounced(),
        .p_edge(debounced_tick),
        .n_edge(),
        .edge_detected()
    );
    
    udl_counter #(.bits(bits)) DEBOUNCED_BUTTON_COUNTER (
        .clk(clk),
        .reset_n(reset_n),
        .enable(debounced_tick),
        .up(1'b1),
        .load(),
        .D(),
        .Q(Q_debounced)
    );
    
    wire noisy_tick;
    wire [3:0] Q_noisy;
    
    edge_detector NOISY_EDGE(
        .clk(clk),
        .reset_n(reset_n),
        .level(button_in),
        .p_edge(noisy_tick),
        .n_edge(),
        .edge_detected()
    );
    
     udl_counter #(.bits(bits)) NOISY_BUTTON_COUNTER (
        .clk(clk),
        .reset_n(reset_n),
        .enable(noisy_tick),
        .up(1'b1),
        .load(),
        .D(),
        .Q(Q_noisy)
    );
    
    assign Noisy_count = Q_noisy;
    assign Debounced_count = Q_debounced;
    
endmodule
