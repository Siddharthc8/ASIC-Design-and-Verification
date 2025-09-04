`timescale 1ns / 1ps




module tb_local_variable_use_case5();

 reg clk = 0;
 
 
 always #25 clk = ~clk;
 
 property p1 ;
 time stime = 0;
 time etime = 0;
 time count = 0;
 
 (1'b1,stime = $realtime) ##1 (1'b1, etime = $realtime, count = (etime - stime), $display("Period (nsec) : %0t",count) ) ;
 
 
 
 endproperty
 
 assert property (@(posedge clk) p1) $info("Suc at %0t",$time);
 
 initial begin 
 $dumpfile("dump.vcd");
 $dumpvars;
// $assertvacuousoff(0);
// #100;
 $finish();
 end
 
 
 endmodule