`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2024 08:42:58 PM
// Design Name: 
// Module Name: tb_mod_m_counter
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


module tb_mod_m_counter();

    // Decalaration 
    localparam m = 10;
    localparam n = $clog2(m);
    localparam T = 20;    // Clcok period 
    
    logic clk, reset;
    logic [$clog2(m)-1:0] q;
    logic saturation;
    
    // Instantiation
    mod_m_counter #(.m(m), .n(n)) uut0(.*);
    
    //Clock 
    always 
    begin
        clk = 1'b0;
        #(T/2);
        clk = 1'b1;
        #(T/2); 
    end
    
    // Test vectors
    initial 
    begin
        reset = 1'b1;
        @(negedge clk)
        reset = 1'b0;
    end

endmodule


























