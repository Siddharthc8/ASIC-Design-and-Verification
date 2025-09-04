`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/20/2024 01:28:15 PM
// Design Name: 
// Module Name: tb_a62
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


module tb_a62;

  reg a = 0;
  reg clk = 0;
  
  always #5 clk = ~clk;
 
  //always #10 a = ~a;
  //always #10 b = ~b;
 
initial begin
  #10;
  a = 1;
  #20;
  a = 0;
  #30;
  a = 1;
  #10;
  a = 0;
end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    $assertvacuousoff(0);
    #100;
    $finish();
  end
 
  assert property ( @(posedge clk) $rose(a) |=> $fell(a)) $info("Suc at 50t", $time);
  else $error ("Fail at %0t", $time);
  
                              
endmodule