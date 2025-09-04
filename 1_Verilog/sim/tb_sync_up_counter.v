`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2024 06:37:16 PM
// Design Name: 
// Module Name: tb_sync_up_counter
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


module tb_sync_up_counter();

    reg clk,reset_n;
    wire [3:0] Q;
    
    sync_up_counter dut(
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
