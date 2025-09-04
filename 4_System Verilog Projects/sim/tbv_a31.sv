`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2024 04:41:58 PM
// Design Name: 
// Module Name: tbv_a31
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


module tbv_a31();
 
reg clk = 0, rst = 0, newd = 0;
reg [11:0] din = 0;
wire sclk, cs, mosi;
  reg [11:0] mosi_out;
 
always #10 clk = ~clk;
 
a31 dut (clk, newd,rst, din, sclk, cs, mosi);
 
initial 
begin
rst = 1;
repeat(5) @(posedge clk);
rst = 0;
 
newd = 1;
din = $urandom;
  $display("%0d", din); 
  for(int i = 0; i <= 11; i++)
    begin
    @(negedge dut.sclk);
    mosi_out = {mosi, mosi_out[11:1]};
    $display("%0d", mosi_out);  
    end
  
  
end
 
 
 
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #2500;
    $stop;
  end
 
endmodule