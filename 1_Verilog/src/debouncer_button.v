`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2024 07:22:26 PM
// Design Name: 
// Module Name: debouncer_button
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


module debouncer_button(
    input clk, reset_n,
    input noisy,
    output debounced,
    output p_edge, n_edge, edge_detected
    );
    
    debouncer_delayed DD0(
        .clk(clk),
        .reset_n(reset_n),
        .noisy(noisy),
        .debounced(debounced)
    );
    
    edge_detector ED0(
        .clk(clk),
        .reset_n(reset_n),
        .level(debounced),
        .p_edge(p_edge),
        .n_edge(n_edge),
        .edge_detected(edge_detected)
    );
endmodule
