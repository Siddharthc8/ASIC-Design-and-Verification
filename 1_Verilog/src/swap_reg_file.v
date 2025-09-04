`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2024 01:01:44 PM
// Design Name: 
// Module Name: swap_reg_file
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


module swap_reg_file
    #(parameter addr_width = 7, data_width = 8)
    (
        input clk, reset_n,
        input we,
        input [addr_width-1:0] address_r, address_w,
        input [data_width-1:0] data_w,
        output [data_width-1:0] data_r,
        // Input for swap functionality
        input [addr_width-1:0] address_A, address_B,
        input swap
    );
    
    wire [1:0] sel;
    wire w;
    wire [addr_width-1:0] mux_read_op, mux_write_op;
    
    reg_file #(.addr_width(addr_width), .data_width(data_width)) REG_FILE(
        .clk(clk),
        .we(w? 1'b1: we),
        .address_w(mux_write_op),
        .address_r(mux_read_op),
        .data_w(w? data_r: data_w),
        .data_r(data_r)
    );
    
    swap_fsm FSM0(
        .clk(clk),
        .reset_n(reset_n),
        .swap(swap),
        .w(w),
        .sel(sel)
    );
    
    mux_4x1_nbit #(.n(addr_width)) MUX_READ (
        .w0(address_r),
        .w1(address_A),
        .w2(address_B),
        .w3('b0),
        .s(sel),
        .f(mux_read_op)       
    );
    
    mux_4x1_nbit #(.n(addr_width)) MUX_WRITE (
        .w0(address_w),
        .w1('b0),
        .w2(address_A),
        .w3(address_B),
        .s(sel),
        .f(mux_write_op)       
    );
endmodule
