`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2024 10:45:28 AM
// Design Name: 
// Module Name: uart
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


module uart
    #(parameter dbit = 8,      // data bits
               sb_tick = 16     // stop bit tick
    )
    (
    input clk, reset_n,
    
    // Receiver port
    output [dbit-1:0] r_data,     // Data coming out of receiver FIFO
    input rd_uart,                 // Like enable to read from FIFO
    output rx_empty,               // Empty flag on Receiver side
    input rx,                      // Data incoming to receiver
    
    // Transmitter port
    input [dbit-1:0] w_data,       // Data to be fed into transmitter FIFO
    input wr_uart,                  // Like enable to write to FIFO   
    output tx_full,                 // Full flag on Receiver side     
    output tx,                      // Data incoming to receiver       
    
    // Baud rate generator
    input [10:0] timer_final_value
    );
    
    // Timer as baud rate generator
    wire tick;
    timer_input #(.n(11)) BAUD_RATE_GENERATOR 
    (
        .clk(clk),                    
        .reset_n(reset_n),                
        .enable(1'b1),                 
        .saturation_value(timer_final_value),
        .done(tick)
    );            
    
    // Receiver
    wire rx_done_tick;
    wire [dbit-1:0] rx_dout;
    uart_rx #(.dbit(dbit), .sb_tick(sb_tick)) RECEIVER
    (
        .clk(clk),
        .reset_n(reset_n),
        .rx(rx),
        .s_tick(tick),
        .rx_done_tick(rx_done_tick),
        .rx_dout(rx_dout)
    );
    
    fifo_generator_0 RX_FIFO
    (
        .clk(clk),              // input wire clk
        .srst(~reset_n),        // input wire srst
        .din(rx_dout),          // input wire [7 : 0] din
        .wr_en(rx_done_tick),   // input wire wr_en
        .rd_en(rd_uart),        // input wire rd_en
        .dout(r_data),          // output wire [7 : 0] dout
        .full(),                // output wire full
        .empty(rx_empty)        // output wire empty
    );
    
    // Transmitter 
    wire tx_fifo_empty, tx_done_tick;
    wire [dbit-1:0] tx_din;
    uart_tx #(.dbit(dbit), .sb_tick(sb_tick)) TRANSMITTER 
    (
        .clk(clk),
        .reset_n(reset_n),
        .tx_start(~tx_fifo_empty),
        .s_tick(tick),
        .tx_din(tx_din),
        .tx_done_tick(tx_done_tick),
        .tx(tx)
    );
    
    fifo_generator_0 TX_FIFO 
    (
        .clk(clk),              // input wire clk
        .srst(~reset_n),        // input wire srst
        .din(w_data),          // input wire [7 : 0] din
        .wr_en(wr_uart),   // input wire wr_en
        .rd_en(tx_done_tick),        // input wire rd_en
        .dout(tx_din),          // output wire [7 : 0] dout
        .full(tx_full),                // output wire full
        .empty(~tx_fifo_empty)        // output wire empty
    );
    
endmodule
















