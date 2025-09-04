`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2024 01:46:12 PM
// Design Name: 
// Module Name: tb_swap_reg_file
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


module tb_swap_reg_file();

    localparam mem_width = 7;
    localparam data_width = 8;
    reg clk, reset_n;
    reg we;
    reg [mem_width-1:0] address_r, address_w;
    reg [data_width-1:0] data_w;
    wire [data_width-1:0] data_r;
    reg [mem_width-1:0] address_A, address_B;
    reg swap;
    integer i;
    
    // Instantiate 
    swap_reg_file #(.mem_width(mem_width), .data_width(data_width)) uut (
        .clk(clk),
        .reset_n(reset_n),
        .we(we),
        .address_r(address_r),
        .address_w(address_w),
        .data_w(data_w),
        .data_r(data_r),
        .address_A(address_A),
        .address_B(address_B),
        .swap(swap)
        );
        
        // Clock 
        localparam T = 10;
        always begin
            clk = 1'b0;
            #(T/2);
            clk = 1'b1;
            #(T/2);
        end
        
        initial begin 
            reset_n = 1'b0;
            #2;
            reset_n = 1'b1;
            swap = 1'b0;
            
            // Fill locations 20 to 30 with some numbers
            for(i=20; i<30; i=i+1)
            begin
                @(negedge clk)
                address_w = i;
                data_w = i;
                we = 1'b1;
            end
            
            @(negedge clk);
            we = 1'b0;
            
            @(negedge clk);
            address_A = 'd22;
            address_B = 'd28;
            swap = 1'b1;
            
            repeat(3) @(negedge clk);
            swap = 1'b0;
            
            #30 $finish;
                        
        end
endmodule
