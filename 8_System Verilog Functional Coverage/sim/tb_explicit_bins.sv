`timescale 1ns / 1ps




module tb_explicit_bins();

  reg  [1:0]  a; /// 00 01 10 11
  reg [7:0] b;
 
covergroup cvr_a_b ;
  
    option.per_instance = 1;
    
    
  coverpoint a {
  
    bins zero = {0};
    bins one  = {1};         //   Sepearte bin for each value
    bins two  = {2};
    bins three = {3};
 
        // OR // 
        
    bins bin0 = {0,1};        //  Mentioning them seperately
    bins bin1 = {[2:3]};      //  Using square brackets for a range ( both inclusive)
    bins bin2 = {[0:2],3};    // Can also mention explicitly the values we want
  
        // OR // 
       
    bins bina = {[0:3]};       //   0 and 3 both inclusive
  
        // OR //
  
  } 
  
  coverpoint b {
  
    bins bin_all[] = {[0:127]};        // Here the array is empty so each vlaue gets a bin
    
    bins bin_couple[64] = {[0:127]};    // Here the array is limited to 64 so will be fit into 64 ie 2 for each bin 
    
    bins bin_vary[]  =  {[0:100], 107, 116 };  //  Can also mention explicitly the values we want since it is empty array will have separate bin
    
    bins unused[] = default;
  }
    
 endgroup 
  
 
  cvr_a_b  ci  =  new();
 
  
  initial begin
    
    for (int i = 0; i < 5; i++) begin
      a = $urandom(); 
      ci.sample();
      #10;
      
    end
  end
    
  endmodule