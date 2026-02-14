`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2024 04:56:26 PM
// Design Name: 
// Module Name: tb_sequence_and_property
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

/*        Sequence and property can take arguments 
Simple Representation     Seqeunce -> Property -> Assertion   */ 
module tb_sequence_and_property();

  reg ce = 0;
  reg wr = 0;
  reg rd = 0;
  reg clk = 0;
  reg rst = 0;
  
    
  always #5 clk = ~clk;
  
  initial begin
    rst = 1;
    #30;
    rst = 0;
  end
 
  initial begin 
    ce = 0;
    #30;
    ce = 1;
  end
  
  initial begin
   #30;
    wr = 1;
   #10;
    rd = 1;
   #20;
    wr = 0;
    rd = 0;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    $assertvacuousoff(0);
    #50;
    $finish;
  end
  
  
  sequence cewr (logic a, logic b);    // mention the opertion sorta thing inside the sequence with arguments
    a && b;
  endsequence
  
  property p1;
    (@(posedge clk) $fell(rst) |-> cewr(ce,wr));    // Call it here just like a function call
  endproperty
 
  
  
  ///////////////////////////////////////////////
  
  
  
  property p2(logic a,logic b);    // While property can also take arguments and mention the function inside the property
    (@(posedge clk) $fell(rst) |=> (a && b));      
  endproperty
  
  ////////////////////////////////////////////////
  
  CHECK_CE_WR:assert property ( p1) $info("p1 CHECK_WR @ %0t", $time);  // Use it in an assertion as usual with property's name
    
  CHECK_CE_rd:assert property (  p2(ce,rd))  $info("p2 CHECK_RD @ %0t", $time); // Can pass arguments as well
    
    
endmodule
