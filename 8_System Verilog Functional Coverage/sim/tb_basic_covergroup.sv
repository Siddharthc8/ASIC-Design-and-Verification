`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2025 03:07:04 PM
// Design Name: 
// Module Name: tb_basic_covergroup
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


module tb_basic_covergroup();

  reg  [1:0]  a;
  wire [1:0]  b;
  integer i = 0;
  
  equals dut (.a(a), .b(b));
  
  
  covergroup cvr_a ; ///// manual sample method as event not mentioned
    
    coverpoint a; //// automaitc bins  
    
    coverpoint b;
  
  endgroup 
  
 
  cvr_a ci = new();
 
  
  initial begin
    
    
    for (i = 0; i <10; i++) begin
      a = $urandom();  
      ci.sample();     // Sample method is used as event is not mentioned in covergroup
      
      #10;
    end
    
    
  end
  
  
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #500;
    $finish();
  end
 
endmodule