`timescale 1ns / 1ps




module tb_consecutive_repetition_transition();
 
  reg clk = 0;
  reg data[] = {1,1,1,1};   
  reg state = 0;
   integer i = 0;
 
 
 
always #5 clk = ~clk;
 
 
  
  initial begin
    for(i = 0; i< 4; i++) begin
      @(posedge clk);
      state = data[i];
    end
  end
 
 
 
 
 
 
  covergroup c @(posedge clk);
    option.per_instance = 1;
    coverpoint state {
      bins trans_0_1 = (0 => 1[*4]);   // Gives false counts as each new 0 starts a new thread
    }
    
    
  endgroup
 
  c ci;
  
 
  
  initial begin
    ci = new();
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #100;
    $finish();
  end
  
 
 
 
 
endmodule