`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2024 11:36:27 PM
// Design Name: 
// Module Name: tb_clkdiv2
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


module tb_clkdiv2();
  
  clkdiv2 dut (
    .clk(clk),
    .rst(rst),
    .f2(f2),
    .f4(f4),
    .f8(f8)
  );
  
  reg clk, rst;
  reg [3:0] count;
  wire f2, f4, f8;
  
    
  always #10 clk = ~clk;
  
  initial begin
    
     clk = 0;
     rst = 1;
    
    #20 rst =0;
    
    
    #100 $finish;
  end

endmodule
