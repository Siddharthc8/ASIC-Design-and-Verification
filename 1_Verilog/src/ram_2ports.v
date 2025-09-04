`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2024 11:41:25 AM
// Design Name: 
// Module Name: ram_2ports
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


module ram_2ports
    #(parameter addr_width = 3, data_width = 8)(
    input clk,
    input we,
    input [addr_width-1:0] r_addr,
    input [addr_width-1:0] w_addr,
    input [data_width-1:0] w_data,
    output [data_width-1:0] r_data
    );
    
    reg [data_width-1:0] memory [0 : 2**(addr_width) - 1];
        
    // Write operation synch
    always @(posedge clk)
    begin
        if(we)
            memory[w_addr] <= w_data;
    end
    
    // Read Operation asynchronous
    assign r_data = memory[r_addr];
    
endmodule
