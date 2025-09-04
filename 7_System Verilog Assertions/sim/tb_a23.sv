`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2024 02:32:14 PM
// Design Name: 
// Module Name: tb_a23
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


module tb_a23();
    reg din, clk=0, rst;
    wire dout;

    a23 dut (din, clk, rst, dout);
    
    always #5 clk = ~clk;
        
    always @(negedge clk)
    begin
        for(int i = 0; i<10; i++)
        begin
            din = $urandom();
            rst = $urandom();
        end
        
    end
    
endmodule
