`timescale 1ns / 1ps




module tb_conditional_coverage();

  reg [1:0] a = 0;
  reg rst = 0;
  integer i = 0;
 
  initial begin
    rst = 1;
    #30;
    rst = 0;
  end
  
 
  covergroup c;
    option.per_instance = 1;
    coverpoint a iff (!rst);      // a is counted only when rst is deasserted
  endgroup
  
  initial begin
    c ci = new();
    for(i = 0; i < 10; i++) begin
      a = $urandom();
      ci.sample();
      #10;
    end
  end
  

  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #100;
    $finish();
  end


endmodule
 