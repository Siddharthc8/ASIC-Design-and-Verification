`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/23/2024 12:21:28 PM
// Design Name: 
// Module Name: tb_fifo
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

module tb_fifo();

    localparam data_width = 8;
    localparam addr_width = 3;
    localparam T = 10; // Clock Period

    logic clk, reset;
    logic wr, rd;
    logic [data_width-1:0] w_data, r_data;
    logic full, empty;
    
    // Instantiate Module
    fifo #(.data_width(data_width), .addr_width(addr_width)) uut 
    (
        .*
    );
    
    // Clock
    always
    begin
        clk = 1'b1;
        #(T/2);
        clk = 1'b0;
        #(T/2);
    end
    
    // Reset 
    initial 
    begin
        reset = 1'b1;
        rd = 1'b0;
        wr = 1'b0;
        
        @(negedge clk);
        reset = 1'b0;
    end
    
    // Test Vectors
    initial
    begin
        // .............EMPTY............
        // Write
        @(negedge clk);
        w_data = 8'd5;
        wr = 1'b1;
        @(negedge clk);
        wr = 1'b0;
        
        // Write
        repeat(1) @(negedge clk);
        w_data = 8'd8;
        wr = 1'b1;
        @(negedge clk);
        wr = 1'b0;
        
        // Write
        repeat(1) @(negedge clk);
        w_data = 8'd2;
        wr = 1'b1;
        @(negedge clk);
        wr = 1'b0;
        
        // Read
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk);
        rd = 1'b0;
        
        // Write
        repeat(1) @(negedge clk);
        w_data = 8'd0;
        wr = 1'b1;
        @(negedge clk);
        wr = 1'b0;
        
        // Write
        repeat(1) @(negedge clk);
        w_data = 8'd9;
        wr = 1'b1;
        @(negedge clk);
        wr = 1'b0;
        
        // Write
        repeat(1) @(negedge clk);
        w_data = 8'd3;
        wr = 1'b1;
        @(negedge clk);
        wr = 1'b0;
        
        // Write
        repeat(1) @(negedge clk);
        w_data = 8'd6;
        wr = 1'b1;
        @(negedge clk);
        wr = 1'b0;
        
        // Write
        repeat(1) @(negedge clk);
        w_data = 8'd1;
        wr = 1'b1;
        @(negedge clk);
        wr = 1'b0;
        
        // Write
        repeat(1) @(negedge clk);
        w_data = 8'd3;
        wr = 1'b1;
        @(negedge clk);
        wr = 1'b0;
        
        // ..................FULL..................
        // Read
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk);
        rd = 1'b0;
        
        // Read
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk);
        rd = 1'b0;
        
        // Read
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk);
        rd = 1'b0;
        
        // Read
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk);
        rd = 1'b0;
        
        // Read
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk);
        rd = 1'b0;
        
        // Read
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk);
        rd = 1'b0;
        
        // Read
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk);
        rd = 1'b0;
        
        // Read
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk);
        rd = 1'b0;
        
        // ..............EMPTY............
        
        // Read and write at the same time
        repeat(1) @(negedge clk);
        w_data = 8'd7;
        wr = 1'b1;
        rd = 1'b1;
        @(negedge clk);
        wr = 1'b0;
        rd = 1'b0;
        
        // Read 
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk);
        rd = 1'b0;
       
       // Write
        repeat(1) @(negedge clk);
        w_data = 8'd4;
        wr = 1'b1;
        @(negedge clk);
        wr = 1'b0;
        
        // Write
        repeat(1) @(negedge clk);
        w_data = 8'd5;
        wr = 1'b1;
        @(negedge clk);
        wr = 1'b0;
        
        // Write
        repeat(1) @(negedge clk);
        w_data = 8'd6;
        wr = 1'b1;
        @(negedge clk);
        wr = 1'b0;
        
        // Read and write at the same time
        repeat(1) @(negedge clk);
        w_data = 8'd7;
        wr = 1'b1;
        rd = 1'b1;
        @(negedge clk);
        wr = 1'b0;
        rd = 1'b0;
        
        repeat(3) @(posedge clk);
        
        $finish;
    end
    
endmodule

