`timescale 1ns / 1ps




module tb_local_variable_use_case3();


 reg clk = 0;
 
 reg req = 0;
 reg ack = 0;
 integer reqcnt = 0;
 integer ackcnt = 0;
 
 always #5 clk = ~clk;
 
 initial begin
 #10;
 req = 1;
 #10;
 req = 0;
 #10;
 req = 1;
 #10;
 req = 0;
 #20;
 ack = 1;
 #10;
 ack = 0;
 #30;
 ack = 1;
 #10;
 ack = 0;
 end
 
 
 
 // assert property (@(posedge clk) $rose(req) |-> ##[1:6] $rose(ack) ) $info("Suc at %0t",$time);
 

 always@(posedge clk)
 begin
 if(req)
 reqcnt <= reqcnt + 1;
 if(ack)
 ackcnt <= ackcnt + 1; 
 end
 
 // Agenda : To find out if each req has its own ack
 property p1;
 
 integer rcnt = 0;
 integer acnt = 0;
 
 // Assigning unique ID using count to make sure the req matches with the right ack
 ($rose(req), rcnt = reqcnt) |-> ##[1:7] ($rose(ack), acnt = ackcnt) ##0 (acnt == rcnt);
 
 endproperty
 
 assert property (@(posedge clk) p1) $info("Suc at %0t",$time);
 
 initial begin 
 $dumpfile("dump.vcd");
 $dumpvars;
// $assertvacuousoff(0);
 #200;
 $finish();
 end
 
endmodule
 