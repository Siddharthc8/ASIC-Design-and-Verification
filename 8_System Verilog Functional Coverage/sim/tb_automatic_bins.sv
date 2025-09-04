`timescale 1ns / 1ps




module tb_automatic_bins();

  reg  [7:0]  a;//256/64 = 4
  reg  [7:0]  b;
  
  
covergroup cvr_a ;
  
    option.per_instance = 1;
    
  coverpoint b;
    
  coverpoint a {
   option.auto_bin_max = 256;    // changing the auto_bin max value which by default is 64
  }                              // Output the value 1 each bin if variable is 64 else it is divided
    
 endgroup 
  
  // RESULT : a has 256 bins where as b has only 64 with 4 in each bin
 
  cvr_a ci = new();
 
  
  initial begin
    
    
    for (int i = 0; i < 5; i++) begin
      a = $urandom(); 
      b = $urandom();
      ci.sample();
      #10;
    end
    
    
  end
  
  endmodule 