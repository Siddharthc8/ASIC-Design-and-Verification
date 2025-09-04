`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/11/2025 11:05:00 PM
// Design Name: 
// Module Name: tb_sample_method_inside_property
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

// Typically used for memories

module tb_sample_method_inside_property();

  reg rd = 0,wr = 0;
  reg clk = 0;
  reg [4:0] addr;    // Trying to see if all ranges are covered
  reg [7:0] din;
  reg [7:0] dout;
  
  always #5 clk = ~clk;

  
  covergroup c with function sample (reg [4:0] addrin);
    option.per_instance = 1;
    coverpoint addrin{
      bins lower = {[0:7]};      // YOu see not all ranges are covered
      bins mid = {[15:20]}; 
      bins high = {[27:31]};
    }
    
  endgroup
 
  c ci;
 
  initial begin
     ci = new();
    
    @(posedge clk);
    addr = 3;
    wr = 1;
    rd = 0;
    din = 12;
    @(posedge clk);
    wr = 0;
    rd = 1;
    addr = 3;
    dout = 12;
    @(posedge clk);
    addr = 17;
    wr = 1;
    rd = 0;
    din = 21;
    @(posedge clk);
    wr = 0;
    rd = 1;
    addr = 17;
    dout = 21;
    @(posedge clk);
    addr = 28;
    wr = 1;
    rd = 0;
    din = 67;
    @(posedge clk);
    wr = 0;
    rd = 1;
    addr = 28;
    dout = 67;
    
    
  end
  
  
 property p1;
  bit [4:0] addrs;    // Local variables
  bit [7:0] dvar;     // Common for din and dout
  // 
   @(posedge clk) ( wr |-> (wr, addrs = addr, dvar = din, ci.sample(addrs)) ##[1:50] rd[*1:50] ##0 (addrs == addr) ##0 (dout == dvar) );
  endproperty
  
  A1: assert property ( p1) $info("Suc at %0t",$time);
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    $assertvacuousoff(0); 
    #500;
    $finish();
  end
  
 
endmodule