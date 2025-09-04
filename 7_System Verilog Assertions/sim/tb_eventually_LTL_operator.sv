`timescale 1ns/1ps

module tb_eventually_LTL_operator();

  reg clk = 0, rst = 1,  ce = 0;
  always #5 clk = ~clk;
  
  
  initial begin
    #20;
    rst = 1;
    #40;
    rst = 1;
    ce = 1;
    #50;
    rst = 1;
    #10;
    ce = 0;
    
    
  end
  
  // General NOTE : Most cases when eventually or s_eventually is used, "initial" before the asssertion is used to limit the checking at all clocks
  
  
  // "always" keyword here make sure that the signal stays the same after trigerred
  initial A1: assert property (@(posedge clk) s_eventually always !rst ) $info("Suc at %0t",$time);
  
  initial A2: assert property(@(posedge clk) s_eventually always !rst) $info("Suc at %0t",$time);
  
  initial A3: assert property (@(posedge clk) s_eventually always ce)  $info("Suc at %0t",$time);
  
  // Can also take a range in which the assertion should check
  initial A4: assert property (@(posedge clk) eventually [2:3] always !rst) $info("Suc at %0t",$time);
  
  initial A5: assert property (@(posedge clk) eventually [2:3] !rst) $info("Suc at %0t",$time);
  
  initial A6: assert property (@(posedge clk) eventually [2:20] !rst) $info("Suc with eventually at %0t",$time);
  
  initial A7: assert property (@(posedge clk) s_eventually [2:20] !rst) $info("Suc with s_eventually at %0t",$time);
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
//    $assertvacuousoff(0);
    #120;
    $finish();
  end 
  
  
endmodule