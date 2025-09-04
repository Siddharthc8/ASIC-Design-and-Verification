`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2024 06:41:23 PM
// Design Name: 
// Module Name: tb_debouncer_delayed
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


module tb_debouncer_delayed();

    reg clk; 
    reg reset_n;
    reg noisy;
    wire debounced;
    integer i;
       
    
    // Instantiate 
    debouncer_delayed uut(
        .clk(clk),
        .reset_n(reset_n),
        .noisy(noisy),
        .debounced(debounced)
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
        #2
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
       
        
        #(delay/2) noisy = 1'b0;
        #(delay) $stop;
                
    end
endmodule
