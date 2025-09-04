`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/03/2025 09:51:48 AM
// Design Name: 
// Module Name: apb_master_yt
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

// APB master from "All about VLSI channel"

module apb_master_yt(
    
    input pclk, presetn,
    input read, write, transfer, pready,
    input [7:0] apb_write_paddr, apb_read_paddr,
    input [7:0] apb_write_data, prdata,
    
    output psel1, psel2,
    output reg penable,
    output reg [8:0] paddr,
    output reg pwrite,
    output reg [7:0] pwdata, apb_read_data_out,
    output pslverr
    
);


//    reg [2:0] curr_state, next_state;
    reg invalid_setup_error;
    reg setup_error, invalid_read_paddr, invalid_write_paddr, invalid_write_data;
    
//    parameter idle = 2'b01, setup = 2'b10, enable = 2'b11;
    typedef enum logic [1:0] { idle = 2'b01, setup = 2'b10, enable = 2'b11} state;
    
    state curr_state, next_state;
    
    always@(posedge pclk) begin
        if(!presetn) 
            curr_state <= idle;
        else
            curr_state <= next_state;
        
    end
    
    
    always@(state,transfer,pready) begin
    
        pwrite = write;
    
    end

endmodule
