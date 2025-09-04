`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2024 11:44:44 PM
// Design Name: 
// Module Name: tb_up_down_counter
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


module tb_up_down_counter();
    localparam bits = 4;
    reg clk,reset_n, enable, up;
    wire [bits-1:0] Q;
    
    up_down_counter #(.bits(bits)) dut(
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .up(up),
        .Q(Q)
        );
        
    // Clock generation 
    localparam T = 10;
    always begin
        clk = 1'b0;
        #(T/2);
        clk = 1'b1;
        #(T/2);   
    end
    
    // Reset the whole system
    initial begin
        reset_n = 1'b0;
        enable = 1'b0;
        up = 1'b1;
     #2 reset_n = 1'b1;   
     
        repeat(2) @(negedge clk);
        enable = 1'b1;
        
        wait(Q == 15);
        enable = 1'b0;
        
        repeat(2) @(negedge clk);
        up = 1'b0;
        enable = 1'b1;
         
    end
    
    initial 
        #400 $stop;
endmodule 
