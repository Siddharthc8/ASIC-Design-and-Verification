`timescale 1ns / 1ps




module tb_wildcard_bins();


  reg [3:0] y;
  wire [1:0] a;
  integer i = 0;
  
  priority_encoder dut (y,a);
  
  covergroup c;
    option.per_instance = 1;
    
    coverpoint y {
      bins zero = { 4'b0001};
      wildcard bins one =   {4'b001?};   // It could either take 0,1,x,z
      wildcard bins two =   {4'b01??};
      wildcard bins three = {4'b1???};   
    }
    
    coverpoint a; 
    
    
  endgroup
  
  c ci;
  
   
  
  initial begin
    ci = new();
    for(i = 0; i<15; i++) begin 
      y = $urandom();
      $display("value of y : %04b",y);
      ci.sample();
      #10;  
    end
    
  end
  
  
  initial begin
  #3000;
  $finish();
  end

  
endmodule