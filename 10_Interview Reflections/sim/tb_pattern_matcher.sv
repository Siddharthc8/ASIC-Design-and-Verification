`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2025 07:18:05 PM
// Design Name: 
// Module Name: tb_pattern_matcher
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


module tb_pattern_matcher();

    reg clk;
    reg [31:0] data;
    wire pat_detected;

    pattern_matcher uut (
        .clk(clk),
        .data(data),
        .pat_detected(pat_detected)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    initial begin
        // Initialize data
        data = 32'h0;
        #20;

        // Test case: Pattern starts at bit 0
        data = 32'hDEADBEEF; // First 32 bits
        #10;
        data = 32'hCAFEBABE; // Last 32 bits
        #10;

        // Test case: Pattern starts at bit 15
        data = 32'h0000DEAD; // Partial pattern
        #10;
        data = 32'hBEEFCAFE; // Middle
        #10;
        data = 32'hBABE0000; // End
        #20;

        $finish;
    end

    initial begin
        $monitor("Time=%0t, data=%h, pat_detected=%b", $time, data, pat_detected);
    end


endmodule
