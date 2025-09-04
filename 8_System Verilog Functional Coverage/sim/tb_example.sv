`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/14/2024 09:18:45 PM
// Design Name: 
// Module Name: tb_example
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


module tb_example();
 
  reg [3:0] a;
  integer i = 0;
  
  covergroup c;
    option.per_instance = 1;  
    coverpoint a;   
  endgroup 
  
  
 
  c ci;
 
  initial begin
    ci = new();
    
    
    for (i = 0; i <50; i++) begin
      a = $urandom();
      ci.sample();
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