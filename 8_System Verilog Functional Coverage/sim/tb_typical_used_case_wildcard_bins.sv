`timescale 1ns / 1ps


module tb_typical_used_case_wildcard_bins();

reg clk = 0, en = 0;
wire [3:0] dout;
  
counter_4 dut (clk,en, dout);
  
  always #5 clk = ~clk;
  
  initial begin
    en = 1;
    #200;
    en = 0;
    #200;
    en = 1;
  end
  
  covergroup c @(posedge clk);
    option.per_instance = 1;
    
    coverpoint {en,dout} {
      
      bins count_off = {5'b00000};
      wildcard bins count_on_low = {5'b100??};// 0-3 --0-3
      wildcard bins count_on_mid = {5'b101??}; // 4-7 100 -111
      wildcard bins count_on_high = {5'b11???}; // 8-15 -- 1000 - 1111
 
    }
    
    
  endgroup
  
  c ci = new();
  
   
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  #700;
  $finish();
  end
  
  
endmodule