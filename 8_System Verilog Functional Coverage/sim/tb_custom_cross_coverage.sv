`timescale 1ns / 1ps




module tb_custom_cross_coverage();

  reg wr;
  reg [1:0] addr;
  reg [3:0] din , dout;
  
  integer i = 0;
 
 
 
  /////////////////////////////
  
  covergroup c_wr_1 ;    // This group covers    wr_high,   addr_ranges,   din_ranges  (dout not needed while writing)
    
     option.per_instance = 1;
    
    coverpoint wr {
      bins wr_high = {1};
    }
   
   coverpoint  addr {
    
     bins addr_v[] = {0,1,2,3}; 
   
   }
    
  coverpoint din {  
      bins low = {[0:3]};
      bins mid = {[4:11]};
      bins hig = {[12:15]};
    }
    
    cross wr, addr, din;
    
  endgroup
  
  ///////////////////////////////
    covergroup c_wr_0;   // This group covers    wr_low(read),   addr_ranges,   dout_ranges  (din not needed while reading)
    
     option.per_instance = 1;
    
    coverpoint wr {
      bins wr_low = {0};
    }
   
   coverpoint  addr {
    
     bins addr_v[] = {0,1,2,3}; 
   
   }
    
  coverpoint dout {  
      bins low = {[0:3]};
      bins mid = {[4:11]};
      bins hig = {[12:15]};
    }
    
    cross wr, addr, dout;
    
  endgroup
  
  ///////////////////////////////////
  
 
  c_wr_1 c1;
  c_wr_0 c2;
  
 
  initial begin
    c1 = new();
    c2 = new();
    
    
    for (i = 0; i <100; i++) begin
      addr = $urandom();
      wr = $urandom();
      din = $urandom();
      dout = $urandom();
      c1.sample();
      c2.sample();
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