`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2025 06:13:02 PM
// Design Name: 
// Module Name: tb_cross_coverage
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


module tb_cross_coverage();

 
  reg wr;
  reg [1:0] addr;
  reg [3:0] din , dout;
  
  integer i = 0;
 
 
 covergroup c ;
   
    option.per_instance = 1;
   
    coverpoint wr {
      bins wr_low = {0};
      bins wr_high = {1};
    }
   
   coverpoint  addr {
    
     bins addr_v[] = {0,1,2,3}; 
   
   }
   
   cross wr, addr;
   ///////////////////////////////
    
    coverpoint din {
    
      bins low = {[0:3]};
      bins mid = {[4:11]};
      bins hig = {[12:15]};
    }
   
    coverpoint dout {
    
      bins low = {[0:3]};
      bins mid = {[4:11]};
      bins hig = {[12:15]};
    }
    
   cross wr,addr, din;
   
   cross wr,addr, dout;
 
    
  endgroup
  
  
  
 
  c ci;
 
  initial begin
    ci = new();
    
    
    
    for (i = 0; i <100; i++) begin
      addr = $urandom();
      wr = $urandom();
      din = $urandom();
      dout = $urandom();
      ci.sample();
      #10;
    end
    
    
  end
  
  
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #1000;
    $finish();
  end
  
 
 
 
 
endmodule