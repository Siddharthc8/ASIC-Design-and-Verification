`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2024 12:21:53 PM
// Design Name: 
// Module Name: tb_disable_assertion
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


module tb_disable_assertion();
 reg a;
 reg rst;
 
 reg clk = 0;
  reg req = 0;
  reg ack = 0;
  reg rst = 0;
  
 always #5 clk = ~clk;
 
    initial begin
    rst = 1;
    #50;
    rst = 0;
    end
     
    initial begin
    #30;
    req = 1;
    #10;
    req = 0;
    #30;
    req = 1;
    #10;
    req = 0;
    ack = 1;
    #10;
    ack = 0;
    end
 
  initial 
  begin
    rst = 1;
    #50;
    rst = 0;
  end
  
  initial 
  begin
    a = 0;
    #50;
    a = 1;
  end
  
  // To disable deferred immediate assertion
  always@(*)
    begin
      A2: assert final (a == 1) $info("Success at %0t", $time); else $error("Failure at %0t", $time);
      
      if(rst == 1'b1)
        disable A2;   // "disable" keyword only allowed on deferred immediate assertion
      
    end
  
  // To disable concurrent assertions
  A3: assert property ( @(posedge clk) disable iff(rst) req |=> ack )$info("Suc at %0t",$time);
  
initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #100;
    $finish;
  end
  
  
endmodule