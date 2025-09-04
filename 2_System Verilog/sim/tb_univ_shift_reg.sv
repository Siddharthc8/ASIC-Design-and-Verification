`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2024 08:08:36 PM
// Design Name: 
// Module Name: tb_univ_shift_reg
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


module tb_univ_shift_reg();

    // Signal decalaration                          
    localparam n = 8;
    logic clk, reset;
    logic [1:0] ctrl;
    logic [n-1:0] d;
    logic [n-1:0] q;
          
    // Instantitation
    univ_shift_reg #(.n(n)) uut (.*);
    
    
    // Clock
    localparam T = 20;
    always 
    begin
        clk = 1'b1;
        #(T/2);
        clk = 1'b0;
        #(T/2);
    end
    
    // Test vectors
    
    // Reset for first half of the cycle
    initial 
    begin
        reset = 1'b1;
        #(T/2);
        reset = 1'b0;
    end
    
    // Incremented every 1 clock cycle
    always 
    begin
        repeat(2) @(negedge clk);
        d = d + 1;
    end
    
    initial 
    begin 
        d = 5;
        ctrl = 2'b11;
        
        #15;
        ctrl = 2'b00;
        
        wait(d==10);
        ctrl = 2'b11;
        
        @(negedge clk);
        ctrl = 2'b01;
        
        #(5 * T);  //     Wait for 100 ns
        $finish;
    end 
    
    // Monitor and Stop
endmodule
