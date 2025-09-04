`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2024 12:09:47 PM
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
    (
        input  logic clk, rst, wr, rd,
        input  logic [7:0] din, 
        output logic [7:0] dout,
        output logic empty, full
    );

    logic [3:0] wptr = 0;
    logic [3:0] rptr = 0;
    logic [4:0] cnt = 0;
    logic [7:0] mem [15:0];
    
    always_ff @(posedge clk) begin
        if(rst) begin
            wptr <= 0;
            rptr <= 0;
            cnt <= 0;
        end
        else if( wr && !full) begin
            mem[wptr] <= din;
            wptr <= wptr + 1;
            cnt <= cnt + 1;
        end
        else if(rd && !empty) begin
            dout <= mem[rptr];
            rptr <= rptr + 1;
            cnt <= cnt - 1;
        end   
    
    end
    
    assign empty = (cnt == 0) ? 1'b1 : 1'b0;
    assign full = (cnt == 16) ? 1'b1: 1'b0;
    
    
endmodule

interface fifo_if;
  
  logic clock, rd, wr;         // Clock, read, and write signals
  logic full, empty;           // Flags indicating FIFO status
  logic [7:0] data_in;         // Data input
  logic [7:0] data_out;        // Data output
  logic rst;                   // Reset signal
 
endinterface




