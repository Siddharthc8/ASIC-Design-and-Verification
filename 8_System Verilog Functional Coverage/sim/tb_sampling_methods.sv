`timescale 1ns / 1ps




module tb_sampling_methods();

  reg  [1:0]  a = 0;
  wire [1:0]  b = 0;
  reg [1:0] y = 0;
  reg en = 0;
  reg clk = 0;
  integer i = 0;
  
  always #5 clk = ~clk;
  
  always #10 en = ~en;
  
  equals dut (.a(a), .b(b));   // "equals" is the module name
  
  
  /////////////////  METHOD  1  /////////////////////////////
  
  covergroup cvr_a @(a); // Sampled at every change of "a"
    
    coverpoint a; //// automaitc bins  
    
    coverpoint b;
  
  endgroup 
  
    /////////////////  METHOD  2  /////////////////////////////
    
   covergroup c1 @(posedge clk);  // Sampled at every posedge 
    option.per_instance = 1;
    
    coverpoint y;
    
  endgroup
  
  /////////////////  METHOD  2  /////////////////////////////
  
  covergroup c2;  //  Initial block changed that it samples every posedge at PREPONED region as we use "manual sample method" (Check 3rd for loop)
    option.per_instance = 1;
    
    coverpoint y;
    
  endgroup
  
  cvr_a ci = new();
  
  c1 ci1 = new();
  
  c2 ci2 = new();
 
  
  initial begin
    
    for (i = 0; i <10; i++) begin
      a = $urandom();    
      #10;
    end
    
    for (i = 0; i <40; i++) begin
      @(posedge clk);
      a = $urandom();
    end
    
    for (i = 0; i <40; i++) begin
      @(posedge clk);
      a = $urandom();
      ci.sample();
    end
    
  end
  
  
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #500;
    $finish();
  end
 
endmodule