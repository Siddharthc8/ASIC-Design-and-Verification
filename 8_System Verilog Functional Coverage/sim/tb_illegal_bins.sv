`timescale 1ns / 1ps




module tb_illegal_bins();

  reg [2:0] opcode;
  reg [2:0] a,b;
  reg [3:0] res;
  integer i = 0;
 
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
    
    coverpoint opcode {
    
      bins valid_opcode[] = {[0:5]};          // We have 6 valid values
      illegal_bins invalid_opcode[] = {6,7};  // 2 unwanted values so we put then in illegal bins
    
     // NOTE :  illegal bins throws an error while ignore bin doesn't
     // NOTE : Illegal bins also get precedence over anyother normal bin
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