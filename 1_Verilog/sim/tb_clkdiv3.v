`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2024 02:32:34 AM
// Design Name: 
// Module Name: tb_clkdiv3
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


module tb_clkdiv3(
    input clk, rst,
    output f3,f5,f9
);

reg [3:0] count,dout;
always @(posedge clk or posedge rst)  begin
    if(rst)
    count <= 0;
    else begin
        if(count == 4'b1111)
            count <= 0;
        else
            count = count +1;
    end
end

always @(negedge clk) begin
    if (rst)
    dout <= 0;
    else
    dout <= count;
end

assign f3 = count[0] | dout[0];
assign f5 = count[1] | dout[1];
assign f9 = count[2] | dout[2];
  
endmodule
