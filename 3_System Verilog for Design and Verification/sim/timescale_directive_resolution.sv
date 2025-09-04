`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 11:24:51 AM
// Design Name: 
// Module Name: timescale_directive_resolution
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


module tb_timescale_directive_resolution();
 
  reg clk16 = 0;
  reg clk8 = 0;  ///initialize variable
  
 
   always #31.25 clk16 = ~clk16;
   always #62.5 clk8 = ~clk8;
  
 
 
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
 
 
  initial begin
    #200;
    $finish();
  end
  
endmodule