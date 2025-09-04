`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2024 07:32:00 PM
// Design Name: 
// Module Name: binary_counter
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


module binary_counter
    #(parameter n= 8)
    (
        input logic clk, reset,   
        output logic max_tick,
        output logic [n-1:0] q
    );
    
    // Signal decalaration
    logic [n-1:0] c_s, n_s;
    
    always_ff @(posedge clk, posedge reset)
    begin
        if (reset)
            c_s <= 0;
        else 
            c_s <= n_s;
    end
    
    // Next state logic
    assign n_s = c_s + 1;
    
    assign max_tick = (c_s == 2**n -1)? 1'b1 : 1'b0;
    
    assign q = c_s;
endmodule
