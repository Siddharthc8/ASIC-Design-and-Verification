`timescale 1ns / 1ps


 
 
/////////////////////////////////////////////////
module tb_counter_project;
  reg clk = 0,rst = 0,up = 0;
 wire [3:0] dout;
  reg temp = 0;
  
  initial begin
    #342;
    temp = 1;
    #10;
    temp = 0;
  end
  
  counter_project dut (clk,rst,up,dout);  
  
  bind counter_project counter_project_assert dut2 (clk,rst,up,dout);
  
  
  always #5 clk = ~clk;
  
  initial begin
    rst = 1;
    #30;
    rst = 0;
    up = 1;
    #200;
    up = 0;
    rst = 1;
    #25;
    rst = 0;
    
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
//    $assertvacuousoff(0);
    #360;
    $finish;
  end
 
 
endmodule