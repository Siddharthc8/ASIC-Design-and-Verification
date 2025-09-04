`timescale 1ns / 1ps




module tb_cross_coverage_ranges();

  reg [2:0] din;
  reg wr;
  int i = 0;
  
   covergroup c ;
   
    option.per_instance = 1;
   
     coverpoint wr
     {
      bins wr_l = {0};
      bins wr_h = {1};
     }
     
     coverpoint din;
     
   //  cross wr, din;
     
     cross wr,din
     {
     
       ignore_bins unused_din = binsof(din) intersect {[5:7]};    // Using a range to ignore
       ignore_bins unused_wr  = binsof(wr) intersect {0};     
     }
     
  
  endgroup
  
  ///////////////////ignore bins to remove from coverage calc
  //////////// bins to include coverage in computation
  
 
  c ci;
 
  initial begin
    ci = new();
    
    
    
    for (i = 0; i <10; i++) begin
      din = $urandom();
      wr = $urandom();
      ci.sample();
      $display("wr : %d din : %0d", wr,din);
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