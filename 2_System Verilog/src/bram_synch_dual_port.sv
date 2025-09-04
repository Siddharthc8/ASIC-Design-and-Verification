`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2024 12:52:59 PM
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
    input logic clk,
    input logic we_a, we_b,
    input logic [addr_width - 1:0] addr_a, addr_b,                  // Read address 
    input logic [data_width - 1:0] din_a, din_b,                    // Write address
    output logic [data_width - 1:0] dout_a, dout_b              // The read data from the address
    );
    
    logic [data_width-1:0] memory [0: 2**(addr_width)-1];
    
    // Port a
    always_ff @(posedge clk)
    begin
        if(we_a)
            memory[addr_a] <= din_a;
            
        dout_a <= memory[addr_a];
    end
    
    // Port b
    always_ff @(posedge clk)
    begin
        if(we_b)
            memory[addr_b] <= din_b;
            
        dout_b <= memory[addr_b];
    end
    
endmodule
