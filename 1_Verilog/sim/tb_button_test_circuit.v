`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2024 01:16:11 PM
// Design Name: 
// Module Name: tb_button_test_circuit
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


module tb_button_test_circuit();
    
    localparam bits = 4;
    reg clk, reset_n;
    reg button_in;
    wire [bits-1:0] Noisy_count, Debounced_count;
    integer i;
    
    // Instantiation 
    button_test_circuit uut (
        .clk(clk),
        .reset_n(reset_n),
        .button_in(button_in),
        .Noisy_count(Noisy_count),             // output
        .Debounced_count(Debounced_count)
    );
    
    // Clock
    localparam T = 10;
    always begin
        clk  = 1'b0;
        #(T/2);
        clk  = 1'b1;
        #(T/2);
    end
    
    localparam delay = 50_000_000;
    
    initial begin
        reset_n = 1'b0;
        button_in = 1'b0;
        #2;
        reset_n = 1'b1;
        
        repeat(2) @(negedge clk);
        button_in  = 1'b1;
        
        #(delay);
        button_in = 1'b0;
        
        #(delay);
        
        repeat(20) @(negedge clk);
        for(i=0; i<5; i=i+1)
            #(delay/40) button_in = ~button_in;          // 0 -> 1
            
            
        #(delay/2);
        for(i=0; i<5; i=i+1)
            #(delay/40) button_in = ~button_in;         // 1 -> 0
        
        
        #(delay/2);
        for(i=0; i<6; i=i+1)
            #(delay/40) button_in = ~button_in;        // 0 -> 0
        
        
        #(delay/2);
        button_in = ~button_in;                        // 0 -> 1
        
        #(delay/2);                                    // 1 -> 1
        for (i=0; i<6; i=i+1)
            #(delay/40) button_in = ~button_in;
        
        // button_in = ~button_in;
        
        #(delay/2) button_in = 1'b0;                   // 1 -> 0
        #(delay/2) $finish;        
                
    end
endmodule






























