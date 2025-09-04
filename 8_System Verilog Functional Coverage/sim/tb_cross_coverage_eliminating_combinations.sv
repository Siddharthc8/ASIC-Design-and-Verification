`timescale 1ns / 1ps




module tb_cross_coverage_eliminating_combinations();

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
   
  
   ///////////////////////////////
    
   coverpoint din { //wr = 1
    
      bins low = {[0:3]};
      bins mid = {[4:11]};
      bins hig = {[12:15]};
    }
   
   coverpoint dout { /// wr = 0
    
      bins low = {[0:3]};
      bins mid = {[4:11]};
      bins hig = {[12:15]};
    }
  
   ////////////////write operation
   cross wr,addr, din 
   {                 //   NOTE : Should only use binsof insode cross_coverage filtering
    ignore_bins wr_low_unused = binsof (wr) intersect {0};  // we are ignoring all values of we = 0 in write
   }
   
   //////////////read operation
   cross wr,addr, dout
   {
     ignore_bins wr_high_unused = binsof (wr) intersect {1};  // We are ignoring all values of wr = 1 in read
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