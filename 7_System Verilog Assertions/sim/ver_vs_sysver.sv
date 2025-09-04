`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2024 06:37:19 PM
// Design Name: 
// Module Name: ver_vs_sysver
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


module ver_vs_sysver();
  
  reg clk = 0;
  reg a = 0;
  reg b = 0;
  
  task a_b();
    #10;
  a = 1;
    #10;
  a = 0;
    #30;
  b = 1;
    #10;
  b = 0;
    #50;
  a = 1;
    #10;
  a = 0;
    #30;
  b = 1;
    #10;
  b = 0;
    
  endtask
  
  always #5 clk =~clk;
  
 
 
  initial begin
    a_b();
  end
 
  
  
  
  /////////////////implementation with verilog
  
  always@(posedge clk)
    begin
      if(a == 1'b1)
         begin
           repeat(4) @(posedge clk);
           if( b == 1'b1)
             $display("Verilog Suc at %0t",$time);
           else
             $error("Verilog Failure at %0t",$time); 
         end
    end
  
  
  
  
  ////////implementation with SVA
  
  A1: assert property ( @(posedge clk)  a |-> ##3 b) $info("SVA Suc at %0t",$time);  
    
    // -> operator checks in the same clock cycle and also the count starts from the same clock
  
    // Check for a and after 4 clock cycles if b is true as well
    
    
      
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    //$assertvacuousoff(0); 
    #200;
    $finish;
  end
    
    
  
endmodule


