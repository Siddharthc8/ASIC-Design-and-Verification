`timescale 1ns / 1ps




module tb_ignore_bins();

  reg [2:0] opcode;
  reg [2:0] a,b;
  reg [3:0] res;
  integer i = 0;
  
  reg [7:0] x;
 
  always_comb
    begin
  case (opcode)     // Note : We have 6 valid values but 8 is the possible way to declare a variable
    0: res = a + b;
    1: res = a - b;
    2: res = a;
    3: res = b;
    4: res = a & b;
    5: res = a | b;
    default : res = 0;
  endcase
    end
  
  covergroup c;
  
    option.per_instance  = 1;
    option.name = "Test";
    
    coverpoint opcode {
    
      bins valid_opcode[] = {[0:5]};          // We have 6 valid values
      ignore_bins invalid_opcode[] = {6,7};  // 2 unwanted values so we put then in illegal bins
    
     // NOTE :  ignore bins doesn't throw an error while ignore bin does
    }
    
    coverpoint x{
    
    bins x_bin[] = {[1:100]};    // Considers all possible values from 1-100
    ignore_bins unused_x = {23,45,67,89,93};    // Ignore all these values from x
    ignore_bins unused_x2  = {[3:7]};         // Excluded a range of values
    bins unused_x1 = default;
    }
  endgroup
  
 
  c ci;
 
  initial begin
     ci = new();  
    
    for (i = 0; i <40; i++) begin
      a = $urandom();
      b = $urandom();
      opcode = $urandom();
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