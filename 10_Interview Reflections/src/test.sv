`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/24/2025 06:13:36 PM
// Design Name: 
// Module Name: test
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


module test(

    input  wire clk,
	input  wire reset_n,
	input  wire[2:0] din1, din2,
	output reg [3:0] pos_edge_count,
	output reg [3:0] neg_edge_count
);
 
always @(posedge clk) begin
	if (!reset_n)
    	pos_edge_count <= 4'b0000;
	else
    	pos_edge_count <= din1;
end
 
always @(posedge clk) begin
	if (reset_n)
    	neg_edge_count <= 4'b0000;
	else
    	neg_edge_count <= din2;
end
 
endmodule