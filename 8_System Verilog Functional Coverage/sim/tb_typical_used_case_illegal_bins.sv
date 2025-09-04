`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2025 11:49:57 PM
// Design Name: 
// Module Name: tb_typical_used_case_illegal_bins
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


module tb_typical_used_case_illegal_bins();

  reg clk = 0;
  reg reset = 0;
  reg din = 0;
  wire dout;
  
 
 fsm_3_states1 dut (reset,clk,din, dout);
  
 always #5 clk = ~clk;
  
  initial begin
    reset = 1;
    #30;
    reset = 0;
    #40;
    din = 1;
  end
 
 
  covergroup c;
    option.per_instance = 1;
    
    coverpoint dut.state iff (!reset){
    
      bins fsmstate[] = {0,1,2};
      illegal_bins unused_state = {3};
    }
    
    coverpoint dut.next_state iff (!reset){
    
      bins fsmstate[] = {0,1,2};
      illegal_bins unused_state = {3};   // This is an illegal state so must throw an error when accessed
    }
    
  endgroup
  
    c ci;
    
    initial begin
      ci = new();
      forever begin
        @(posedge clk);
        ci.sample();
      end
    end
 
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #300;
    $finish();
  end
  
 
endmodule
 