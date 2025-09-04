`timescale 1ns / 1ps




module tb_covergroup_options();

  reg  [1:0]  a; //00 01 10 11
  wire [1:0]  b;
  integer i = 0;
  
  equals dut (.a(a), .b(b));
  
  
  covergroup cvr_a ; ///// manual sample method
    
    option.per_instance = 1;     // Gives analysis of each coverpoint
    option.name = "COVER_A_B";   // Assigning name to the covergroup instance
    option.goal = 70;            // To nodify the goal percentage
    option.at_least = 4;         // Each occurance should atleast have 4 hits
    option.auto_bin_max = 2;     // TO control the number of automatic bins (default = 64)
    
    coverpoint a; //// automaitc bins  
    
    coverpoint b;
  
  endgroup 
  
 
  cvr_a ci = new();
 
  
  initial begin
    
    
    for (i = 0; i <10; i++) begin
      a = $urandom();  
      ci.sample();
      
      #10;
    end
    
    
  end
  

  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #500;
    $finish();
  end
  

 
endmodule