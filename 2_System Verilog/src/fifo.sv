`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2024 11:40:49 AM
// Design Name: 
// Module Name: fifo
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


module fifo
    #(parameter addr_width = 3, data_width = 8)
    (
        input  logic clk, reset,
        input  logic wr, rd,
        output logic full, empty,
        input  logic [data_width - 1:0] w_data,
        output logic [data_width - 1:0] r_data
    );
    
    // Signal Declarations
    logic [addr_width - 1:0] w_addr, r_addr;
    
    // Instantiate reg file
    reg_file #(.addr_width(addr_width), .data_width(data_width)) r_file_unit
    (
        .*,
        .w_en(wr & ~full)        
    );
    
    // Instantiate fifo controller
    fifo_ctrl #(.addr_width(addr_width)) ctrl_unit
    (
        .*
    );
    
    
endmodule
