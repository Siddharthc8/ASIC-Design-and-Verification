`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2024 05:50:05 PM
// Design Name: 
// Module Name: tb_implication_operators
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


module tb_implication_operators();
  
  reg clk = 0;
  
 
  reg req = 0;
  reg ack = 0;
  
  task req_stimuli(); 
   #10;
   req = 1;
   #10;
   req = 0;
   #10;
   req = 1;
   #10;
   req = 0;
   #10;
   req = 1;
   #10;
   req = 0;     
   endtask
  
  
 task ack_stimuli(); 
   #10;
   ack = 1;
   #10;
   ack = 0;
   #10;
   ack = 0;
   #10;
   ack = 0;
   #10;
   ack = 0;
   #10;
 endtask
  
  
  
  initial begin
  
  fork
   req_stimuli();
   ack_stimuli();
  join
  
  end
 
  
  always #5 clk = ~clk;
  
  // Overlapping ie to check in the same clock cycle
  A1 : assert property (@(posedge clk) req |-> ack) $info("Overlapping Suc at %0t", $time); else $error("Overlapping Failure at %0t",$time); 
  
  // Non-Overlapping ie to check in the next clock cycle
  A2 : assert property (@(posedge clk) req |=> ack) $info("Non-Overlapping Success @ %0t", $time); else $error("Failure @ %0t", $time);
  
  
  initial begin 
    $dumpfile("dump.vcd");
    $dumpvars;
    #60;
    $finish();
  end
 
endmodule
