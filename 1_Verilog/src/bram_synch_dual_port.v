`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2024 08:05:10 PM
// Design Name: 
// Module Name: bram_synch_dual_port
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


module bram_synch_dual_port
    #(parameter addr_width = 10, data_width = 8)(
    input clk,
    input we_a, we_b,
    input [addr_width - 1:0] addr_a, addr_b,                  // Read address 
    input [data_width - 1:0] din_a, din_b,                    // Write address
    output reg [data_width - 1:0] dout_a, dout_b              // The read data from the address
    );
    
    reg [data_width-1:0] memory [0: 2**(addr_width)-1];
    
    //  Port a
    always @(posedge clk)
    begin
        if(we_a)                           // write
            memory[addr_a] <= din_a;       // write
            
        dout_a <= memory[addr_a];          // Read data feom address A 
    end
    
    always @(posedge clk)
    begin
        if(we_b)                           // write
            memory[addr_b] <= din_b;       // write
            
        dout_b <= memory[addr_b];          // Read data from address A 
    end
endmodule
