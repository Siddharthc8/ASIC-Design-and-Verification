`timescale 1ns / 1ps


module tb_weight();

  reg [1:0] a;
  reg [1:0] b;
  integer i = 0;
  
 
 covergroup c;
   option.per_instance = 1;
   
   coverpoint a
   {
   option.weight = 5;            // w(a) + w(b) / n    =    50%(3) + 75%(3) / 8     
   }                             // % is the output after analysis
   
   
   coverpoint b{
   option.weight = 3;
   }
   
 endgroup
 
 
  initial begin
    c ci = new();
    
    
    
    for (i = 0; i <5; i++) begin
      a = $urandom();
      b = $urandom();
      ci.sample();
      #10;
    end
    
    
  end
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #200;
    $finish();
  end


endmodule