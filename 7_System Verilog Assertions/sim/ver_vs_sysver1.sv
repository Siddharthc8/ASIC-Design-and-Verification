`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2024 07:38:39 PM
// Design Name: 
// Module Name: ver_vs_sysver1
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


module ver_vs_sysver1();

  reg clk = 0;
  reg start = 0;
  integer i = 0;
  integer count = 0;
   
  
  initial begin
    #80;
    start = 0;
    #10;
    start = 1;
  end
  
  
  
  always #5 clk =~clk; ///period 10ns  
 
 
  
  task check();
    for(i = 0; i < 20; i++) begin
      @(posedge clk);
      if(start == 1'b1)
         count++;
    end
  endtask  
    
 initial begin
   check();
   if(count > 0)
     $display("Verilog Suc at %0t",$time);
   else
     $error("Verilog Failure at %0t",$time);
 end
    
    
    
  /////SVA
  
  initial assert property (@(posedge clk) s_eventually start) $display("SVA Suc at %0t",$time);
  
  // Command checks if "start" occurs eventually 
  
  
  
initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    $assertvacuousoff(0); 
    #200;
    $finish;
  end
  
  
endmodule
