`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2025 09:00:53 PM
// Design Name: 
// Module Name: multiple_master_multiple_slave
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


module multiple_master_multiple_slave(

    );
endmodule

interface MM_if(input logic clk, input logic rst);

    logic m_valid;
    logic m_ready;
    logic m_sop;
    logic m_eop;
    logic [31:0] m_data;
    logic [3:0] m_keep;
    logic  [11:0] m_length;
    logic  [1:0] m_dest;
    logic [1:0] m_src;
    logic [7:0] m_crc;
    
    
    // Clocking block for driver
    clocking cb_drv @(posedge clk);
        output m_valid, m_sop, m_eop, m_data, m_keep, m_dest, m_src, m_crc;
        input m_ready;
    endclocking

endinterface