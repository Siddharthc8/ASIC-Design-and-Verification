`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/25/2025 08:23:26 PM
// Design Name: 
// Module Name: tb_tester_me
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


module tb_tester_me();

    initial begin
        repeat(10) begin
            $display("------>>>>>This is running");
        end
    end
endmodule
