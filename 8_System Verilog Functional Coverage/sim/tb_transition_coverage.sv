`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2025 10:05:26 PM
// Design Name: 
// Module Name: tb_transition_coverage
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


module tb_transition_coverage();

reg clk = 0, din = 0, rst = 0;
wire dout;
 
fsm dut (clk,din,rst,dout);
 
always #5 clk = ~clk;
 
 
 
 
initial begin
  repeat(4) @(posedge clk) {rst,din} = 2'b10;
  repeat(4) @(posedge clk) {rst,din} = 2'b01;
  repeat(4) @(posedge clk) {rst,din} = 2'b10;
  repeat(1) @(posedge clk) {rst,din} = 2'b01;
  repeat(4) @(posedge clk) {rst,din} = 2'b00;
end
  
  
  
  
 
  covergroup c1 @(posedge clk);   // All values of din = 1;
    
  option.per_instance = 1;
    
    coverpoint rst {
      bins rst_l = {0};
      bins rst_h = {1};
    }
    
    coverpoint din {
      bins din_h = {1};
    }
    
     coverpoint dout {
      bins dout_l = {0};
      bins dout_h = {1};
    }
 
    coverpoint dut.state iff (din == 1'b1) {
      
      bins trans_s0_S1 = (dut.s0 => dut.s1);   
      bins trans_s1_S0 = (dut.s1 => dut.s0);
      illegal_bins same_state = (dut.s0 => dut.s0, dut.s1 => dut.s1);
   
    
    
    }
    
    cross rst,din,dut.state
    {
      ignore_bins rst_high = binsof(rst) intersect{1};   
    }
    
  endgroup
 
  
  covergroup c2 @(posedge clk);   // All values of din = 0; 
      option.per_instance = 1;
    
       coverpoint din {
      bins din_l = {0};
    }
    
    coverpoint dut.state iff (din == 1'b0) {
         
      bins trans_s0_S0 = (dut.s0 => dut.s0);      
      bins trans_s1_S1 = (dut.s1 => dut.s1);
      illegal_bins diff_state = (dut.s0 => dut.s1, dut.s1 => dut.s0);
     
    }
    
    cross rst,din,dut.state {
      ignore_bins rst_high = binsof(rst) intersect{1};   
    }
    
  endgroup
 
 
  c1 ci;
  c2 ci2;
 
  
  
  
  
  initial begin
    ci = new();
    ci2 = new();
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #500;
    $finish();
  end
  
 
 
 
 
endmodule