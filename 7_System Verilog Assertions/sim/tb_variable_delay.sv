module tb_variable_delay;

 reg clk = 0;
 
 reg req = 0;
 reg ack = 0;
 
 always #5 clk = ~clk;
 
 initial begin
 repeat(3) 
 begin
 #1;
 req = 1;
 #5;
 req = 0;
 repeat(3) @(negedge clk);
 end
 end
 
 initial begin
 #34;
 ack = 1;
 #5;
 ack = 0;
 #14;
 ack = 1;
 #5;
 ack = 0;
 #60;
 ack = 1;
 #5;
 ack = 0;
 
 end
 
 // Executes and checks all the clock ticks in the mentioned range (BOTH numbers included)
 A1: assert property (@(posedge clk) $rose(req) |-> ##[2:5] $rose(ack)) $info("Suc @ %0t",$time);
 
 // NOTE:       ##[*]    =    ##[ 0:$ ]
 //             ##[+]    =    ##[ 1:$ ]   
 
 
 initial begin 
 $dumpfile("dump.vcd");
 $dumpvars;
 $assertvacuousoff(0);
 #140;
 $finish();
 end
 
endmodule