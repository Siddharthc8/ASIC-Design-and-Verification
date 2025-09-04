`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2024 02:54:37 AM
// Design Name: 
// Module Name: tb_compare_storage_elements
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


module tb_compare_storage_elements();

    reg D, clk;
    wire Q_latch, Q_ff_pos, Q_ff_neg;
    
    compare_storage_elements uut(
    .D(D),
    .clk(clk),
    .Qa(Q_latch),
    .Qb(Q_ff_pos),
    .Qc(Q_ff_neg)
    );
    
    localparam T = 20; // Clock Period
    always
    begin
        clk = 1'b0;
        #(T/2);
        clk = 1'b1;
        #(T/2);     
    end
    
    initial begin
        D = 1'b1;
        #(2*T)
        D = 1'b0;
        
        @(posedge clk);
        D = 1'b1;
        
        #2 D = 1'b0;
        #3 D = 1'b1;
        #4 D = 1'b0;
        
        repeat(2) @(negedge clk);
        D = 1'b1;
        
        #20 $stop;
    end
endmodule
