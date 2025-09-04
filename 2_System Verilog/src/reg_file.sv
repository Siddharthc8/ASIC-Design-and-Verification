`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 

// Create Date: 06/21/2024 11:41:44 AM
// Design Name: 
// Module Name: reg_file
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


module reg_file
    #(parameter addr_width = 3, data_width = 8)
    (
        input  logic clk,
        input  logic w_en,
        input  logic [addr_width -1: 0] r_addr,
        input  logic [addr_width -1: 0] w_addr,
        input  logic [data_width -1: 0] w_data,
        output logic [data_width -1: 0] r_data
    );
    
    // Signal decalaration
    logic [data_width -1: 0] memory [0: 2**addr_width - 1];
    
    // Write operation
    always_ff @(posedge clk)
    begin
        if(w_en)
            memory[w_addr] <= w_data;
    end
    
    // Read Operation
    assign r_data = memory[r_addr]; 
endmodule
