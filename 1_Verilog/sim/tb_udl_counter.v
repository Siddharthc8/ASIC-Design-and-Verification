`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2024 03:00:11 PM
// Design Name: 
// Module Name: tb_udl_counter
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


module tb_udl_counter();

// Input output declaration
    localparam bits = 4;
    reg clk, reset_n, enable, up, load;
    reg [bits-1:0] D;
    wire [bits-1:0] Q;
    
    // Instantitiate the module under test
    udl_counter #(.bits(bits)) uut(
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable), 
        .up(up),     
        .load(load),
        .D(D),
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
    
    initial begin
        // Quick reset
        reset_n = 0;
        up = 1'b1;
        enable =  1'b0;
        load = 1'b0;
     #2 reset_n = 1'b1;
         
        repeat(2) @(negedge clk);
        enable = 1'b1;
        
        wait (Q==15);
        enable = 1'b0;
        
        repeat(2) @(negedge clk);
        enable = 1'b1;
        up = 1'b0;
        
        repeat(2) @(negedge clk);
        D = 9;
        load = 1'b1;
        
        @(negedge clk);
        load = 1'b0;
        
        wait(Q==2);
        D = 7;
        load = 1'b1;
        
        repeat(2) @(negedge clk);
        load = 1'b0;
        
        repeat(5) @(negedge clk);
        D = 11;
        up = 1'b1;
        load = 1'b1;
        
        repeat(2) @(negedge clk);
        up = 1'b1;
        load = 1'b0;
    end
    
    initial
    #400 $stop;
        
    
endmodule















