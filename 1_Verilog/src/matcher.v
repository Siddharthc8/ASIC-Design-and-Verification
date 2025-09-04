`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2024 01:16:16 PM
// Design Name: 
// Module Name: matcher
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


module matcher(
input wire clk,
input wire rst,
input wire datain,
output reg error,
output reg found
);

reg [8:0] cnt;
reg [2:0] dly;

always @(posedge clk) 
begin

	if (rst) begin
	dly <= 0;
	cnt <= 0;
	error <= 0;
	found <= 0;
	end		

	else begin
	dly[0] <= datain;
	dly[1] <= dly[0];
	dly[2] <= dly[1];
	cnt <= cnt + 1;

		if ( cnt == 128 ) begin
		error <= 1;
		end

		else begin
		error <= 0;
		end

		if ( dly == 3'b101 ) begin 
		found <= 1;
		end

		else begin
		found <= 0;
		end 
	end
end
endmodule

