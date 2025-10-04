`timescale 1ns / 1ps




module tb_with_keyword_bin_filtering();

  reg [3:0] a; /// 0 -15 
  integer i = 0;
  
  reg [3:0] b;
  reg [7:0] btemp;
  int x;
 
  covergroup c;
    option.per_instance = 1;
    
    coverpoint a {
      bins zero = {0};
      
      bins odd_a1  = {1,3,5,7,9,11,13,15};
      bins even_a1 = {2,4,6,8,10,12,14};
     
     // "with" and "item" keywords are used to mention all the conditions
      bins odd_a = a with ( (item > 0) && (item % 2 == 1) );    // To check for odd numbers 
      bins even_a = a with ( (item > 0) && (item % 2 == 0) );   // To check for even numbers 
      
      bins mul_3 = a with ( (item >0) && (item % 3 == 0) ); // To check for multiples of 3
     
    }   
    
    coverpoint b{
    
    bins b_div5 = {[1:100]} with ( item % 5 == 0);     // To check for multiples of 5 and only in range 1-100
    
    }
    
  endgroup
  
 
  c ci;
 
  initial begin
     ci = new();
    
    
    for (i = 0; i <20; i++) begin
      a = $urandom();
      $display("Value of a : %0d",a);
      ci.sample();
      #10;
    end
    
    for (i = 0; i <20; i++) begin
      btemp = $urandom();
      x = btemp;                      // Just using btemp(7-bit) and x as a medium to display
      $display("Value of x : %0d",x);  // Since btemp is 8 bits and x is 32 bit integer type rest of the values will be 0
      ci.sample();
      #10;
    end
    
  end
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #400;
    $finish();
  end
  
 

endmodule