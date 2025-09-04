`timescale 1ns / 1ps


module tb_default_bins();

  reg [3:0] a;  /// 0 -15 
 
  integer i = 0;
  
  
  initial begin
    #100;
    $finish();    
  end
  
 covergroup c;
   
   option.per_instance = 1;
   coverpoint a {
     bins a_values[] = {[0:9]}; 
     
     bins a_unused = default;    // Displays number of occurances of all unmentioned values 
     
     bins a_unused1[]  = default;  // Displays all the numbers
     
     bins a_unused2[4]  = default;  // Displays the number of occurances but splits them into 4 groups
   }
   

 endgroup

  
  initial begin
    c ci = new();
    for(i = 0; i < 30; i++) begin 
      a = $urandom();
      ci.sample();
    end 
  end
 
endmodule