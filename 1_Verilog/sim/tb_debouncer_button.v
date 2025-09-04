`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2024 07:28:11 PM
// Design Name: 
// Module Name: tb_debouncer_button
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


module tb_debouncer_button();

    reg clk; 
    reg reset_n;
    reg noisy;
    wire debounced;
    wire p_edge, n_edge, edge_detected;
    integer i;
       
    
    // Instantiate 
    debouncer_button uut(
        .clk(clk),
        .reset_n(reset_n),
        .noisy(noisy),
        .debounced(debounced),
        .p_edge(p_edge),
        .n_edge(n_edge),
        .edge_detected(edge_detected)
    );
    
    //Clock
    localparam T = 10;
    always begin
        clk = 1'b0;
        #(T/2);
        clk = 1'b1;
        #(T/2);
    end
    
    localparam delay = 50_000_000;
    
    initial begin
        reset_n = 1'b0;
        noisy = 1'b0;
        #2;
        reset_n = 1'b1; 
        
        repeat(2) @(negedge clk);
        noisy = 1'b1;
        
        #(delay);
        noisy = 1'b0;
        
        #(delay);
        
        repeat(20) @(negedge clk);
        for(i=0; i<5; i=i+1) 
            #(delay/40) noisy = ~noisy;
        
        
        #(delay/2);        
        for(i=0; i<5; i=i+1) 
            #(delay/40) noisy = ~noisy;
         
        
        #(delay/2); 
        noisy = ~noisy;
        for(i=0; i<5; i=i+1) 
            #(delay/40) noisy = ~noisy;
        
        
        #(delay/2);
        noisy = ~noisy;
        
        #(delay/2);
        for (i=0; i<5; i=i+1)
            #(delay/40) noisy = ~noisy;
       
        noisy = ~noisy;                           // Extra
        
        #(delay/2) noisy = 1'b0;
        #(delay) $finish;
                
    end
endmodule


