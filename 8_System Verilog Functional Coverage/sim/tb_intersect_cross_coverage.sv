`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2025 08:10:10 PM
// Design Name: 
// Module Name: tb_intersect_cross_coverage
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


module tb_intersect_cross_coverage();

  reg wr;
  reg [1:0] addr;
 
  
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
   
  
   //cross wr, addr;
   cross wr,addr
   {
    
    bins wr_low  = binsof (wr) intersect {0};        // Sums the total no of occurances of wr = 0 and makes a separate goal contributor
    
                    // OR //
    
    ignore_bins wr_low_unused = binsof (wr) intersect {0};   // To avoid the contribution use ignore bins
     
   }
 
    
  endgroup
  
  ///////////////////ignore bins to remove from coverage calc
  //////////// bins to include coverage in computation
  
 
  c ci;
 
  initial begin
    ci = new();
    
    
    
    for (i = 0; i <100; i++) begin
      addr = $urandom();
      wr = $urandom();
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