module tb_unbounded_delay;

 reg clk = 0;
 
 reg req = 0;
 reg ack = 0;
 
 always #5 clk = ~clk;
 
 initial begin
 #2;
 req = 1;
 #5;
 req = 0;
 end
 
 initial begin
 #120;
 ack = 0;
 #10;
 ack = 0;
 
 end
 
 // The range is mentioned and 0 means from the same clock tick to all the way to the end
 // Does not return any Fail message as it assumes the values is True somewhere after simulation
 A1: assert property (@(posedge clk) $rose(req) |-> ##[0:$] $rose(ack) ) $info("Suc @ %0t",$time);
 
 // To make the property strong and return a fail message after the simulation use the keyword "STRONG" before the range
 A2: assert property (@(posedge clk) $rose(req) |-> strong( ##[0:$] $rose(ack) )   )  $info("Suc @ %0t",$time);
 
  // NOTE:       ##[*]    =    ##[ 0:$ ]
 //             ##[+]    =    ##[ 1:$ ]  
 
 initial begin 
 $dumpfile("dump.vcd");
 $dumpvars;
// $assertvacuousoff(0);
 #140;
 $finish();
 end
 
endmodule