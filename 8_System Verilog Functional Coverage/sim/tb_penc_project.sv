`timescale 1ns / 1ps




module tb_penc_project();

  reg [7:0] y;
  wire [2:0] a;
  integer i = 0;
  
  
  covergroup c;
    option.per_instance = 1;
    coverpoint y {                          // Just checking using wildcard bins is enough. Not much of cross combinations
      bins zero = { 8'b00000001};
      wildcard bins one =   {8'b0000001?};
      wildcard bins two =   {8'b000001??};
      wildcard bins three = {8'b00001???};
      wildcard bins four =  {8'b0001????};
      wildcard bins five =  {8'b001?????};
      wildcard bins six =   {8'b01??????};
      wildcard bins seven = {8'b1???????};
    
    }
    
    coverpoint a; 
    
    
  endgroup
  
  c ci;
  
  penc dut (y,a); 
  
  initial begin
    ci = new();
    for(i = 0; i<300; i++) begin 
      y = $urandom();
      ci.sample();
      #10;  
    end
    
  end
  
  
  initial begin
  #3000;
  $finish();
  end
  
  
  
  
  
endmodule