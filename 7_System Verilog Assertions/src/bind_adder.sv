`timescale 1ns / 1ps



// Simple adder module for bind

module bind_adder (
  input [3:0] a,b,
  output [4:0] y
);  
  
  
assign y =  a + b;
  
endmodule