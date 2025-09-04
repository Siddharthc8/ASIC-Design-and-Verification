`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2024 12:10:51 PM
// Design Name: 
// Module Name: ram_2port
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


module ram_2port
    #(parameter addr_width = 3, data_width = 8)(
    input logic clk,
    input logic we,
    input logic [addr_width-1:0] r_addr,
    input logic [addr_width-1:0] w_addr,
    input logic [data_width-1:0] w_data,
    output logic [data_width-1:0] r_data
    );
    
    // Memory
    logic [data_width-1:0] memory [0: 2**addr_width-1];
    
    // Write operations
    always_ff @(posedge clk)
    begin
        if(we)
            memory[w_addr] <= w_data;
    end
    
    // Read operations
    assign r_data = memory[r_addr];
    
endmodule
