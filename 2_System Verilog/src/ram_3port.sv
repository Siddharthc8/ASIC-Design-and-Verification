`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2024 12:20:07 PM
// Design Name: 
// Module Name: ram_3port
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


module ram_3port
    #(parameter addr_width = 3, data_width = 8)(
    input logic clk,
    input logic we,
    input logic [addr_width-1:0] r_addr0, r_addr1,
    input logic [addr_width-1:0] w_addr,
    input logic [data_width-1:0] w_data,
    output logic [data_width-1:0] r_data0, r_data1
    );
    
    // Memory
    logic [data_width-1:0] memory [0: 2**addr_width-1];
    
    // Write operations
    always_ff @(posedge clk)
    begin
        if(we)
            memory[w_addr] <= w_data;     // 1 synchronous write
            r_data1 = memory[r_addr1];    // 1 synchronous reads
    end
    
    // Read operations
    assign r_data0 = memory[r_addr0];     // 1 asynchronous reads
    
    
endmodule
