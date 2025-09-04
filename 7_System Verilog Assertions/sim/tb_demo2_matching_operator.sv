`timescale 1ns / 1ps




module tb_demo2_matching_operator();

  reg clk = 0,start,sclk = 0,en = 0;
  
  always #5 clk = ~clk;
  always #5 sclk = ~sclk;
  
  reg [3:0] dout = 0;
  
  
  initial begin
  #10;
    en = 1;
    #10;
    en = 0;
    
  end
  
    initial begin
   start = 0;
    #20;
   start = 1;
   #50;
   start = 0;
  end
  
  // Agenda : sclk continuously toggling when start is high
  
  // Checks whenever start is high at both the edges and gives us new instance evertime start is triggered
  A1 : assert property (@(edge clk) ##1 start |-> start throughout ($changed(sclk))) $info("A1 Suc at %0t",$time);  
  
  // Checks at both the edges but gives fail wherever start is low. can use "disable iff(!start) to avoid this
  A2 : assert property (@(edge clk) ##1 start throughout ($changed(sclk))) $info("A2 Suc at %0t",$time);
  
  // Gives only one success as we are usign $rose
  A3 : assert property (@(edge clk) ##1 $rose(start) |-> start throughout ($changed(sclk))) $info("A3 Suc at %0t",$time);
  
  
  // Usign edge has its own adavntage where both the ref clock and the signal are of the same freq. The $changed prepone value will always be the same @(posedge)
  // We can use $stable but also will give true when the signal is always stable 
  
  
  initial begin
    $dumpvars;
    $dumpfile("dump.vcd");
//    $assertvacuousoff(0);
    #100;
    $finish;
  end
 
  
    
endmodule