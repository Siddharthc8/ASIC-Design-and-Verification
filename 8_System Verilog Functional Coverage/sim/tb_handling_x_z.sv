`timescale 1ns / 1ps




module tb_handling_x_z();


  reg [3:0] y;
  wire [1:0] a;
  integer i = 0;
  
  priority_encoder dut (y,a);
  
  covergroup c;
    option.per_instance = 1;
    
    coverpoint y {
      bins zero = { 4'b0001};
      wildcard bins one =   {4'b001?};
      wildcard bins two =   {4'b01??};
      wildcard bins three = {4'b1???};   
    }
    
    coverpoint a
    {
      // Should manually be mentioned so it can be captured
      bins undef = {2'bxx, 2'bx0, 2'b0x, 2'b1x, 2'bx1,2'bzz, 2'bz0, 2'b0z, 2'b1z, 2'bz1};
      bins valid[] = {0,1,2,3};
      
    }
    
    
  endgroup
  
  c ci;
  
 
  initial begin
    ci = new();
    for(i = 0; i<15; i++) begin 
      y = $urandom();
      $display("value of y : %04b and a : %02b @%0t ",y, a , $time);
      ci.sample();
      #10;  
    end
    
  end
  
  
  initial begin
  #3000;
  $finish();
  end
  
  
endmodule