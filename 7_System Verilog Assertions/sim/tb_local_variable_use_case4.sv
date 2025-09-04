`timescale 1ns / 1ps




module tb_local_variable_use_case4();

 reg clk = 0;
 
 reg req = 0;
 reg ack = 0;
 int delay = 0;
 
 
 always #5 clk = ~clk;
 
 initial begin
 for(int i = 0; i < 5 ; i ++) 
 begin
 @(posedge clk);
 delay = $urandom_range(4, 6);
 req = 1;
 @(posedge clk);
 req = 0;
 repeat(delay) @(posedge clk);
 ack = 1;
 @(posedge clk);
 ack = 0;
 end
 end
 
 
 
 property p1 (count);  // Count is where we mention the desired delay diff between req and ack
 time stime;
 time etime;
 
 
 ($rose(req), stime = $realtime) |-> ##[1:$] ($rose(ack),etime = $realtime) ##0 (((etime - stime) == count) , $display("Diff : %0t", etime - stime));
 
 //$rose(req) |-> ##5 $rose(ack);
 endproperty
 
 assert property (@(posedge clk) p1(50)) $info("Suc at %0t",$time);
 
 initial begin 
 $dumpfile("dump.vcd");
 $dumpvars;
// $assertvacuousoff(0); 
// #500;
 $finish();
 end
 
endmodule