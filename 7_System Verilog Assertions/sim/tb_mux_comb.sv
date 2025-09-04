`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2024 11:56:55 AM
// Design Name: 
// Module Name: tb_mux_comb
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


module tb_mux_comb();

  reg a = 0,b = 0,c = 0 ,d = 0;  
  reg [1:0] sel;
  wire y;
  
  
  mux_comb dut (a,b,c,d,sel,y);
  
  
  always #5 a = ~a;
  always #10 b = ~b;
  always #15 c = ~c;
  always #20 d = ~d;
  
  initial begin
    sel = 2'b00;
    #50;
    sel = 2'b01;
    #50;
    sel = 2'b10;
    #50;
    sel = 2'b11;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #300;
    $finish;
  end
  
  
  
endmodule
