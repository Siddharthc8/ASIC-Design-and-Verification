`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2024 10:19:38 PM
// Design Name: 
// Module Name: tb_up_counter
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


module tb_up_counter();

    localparam bits = 4;
    reg clk,reset_n;
    wire [bits-1:0] Q;
    
    up_counter #(.bits(bits)) dut(
        .clk(clk),
        .reset_n(reset_n),
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
     #2 reset_n = 1'b1;    
    end
    
    initial 
        #200 $stop;
endmodule 
