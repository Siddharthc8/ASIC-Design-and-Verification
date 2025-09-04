`timescale 1ns / 1ps

// To write all assertions in this module and bind them with the testbench later

module bind_adder_assert (
  input [3:0] a,b,       // All the directions should be input irrespective of whether it is inout or output 
  input [4:0] y          // All the directions should be input irrespective of whether it is inout or output 
);
 
A1: assert #0 (y == a + b) $info("Suc @ %0t", $time);
 
 
endmodule



// NOTE : This is a SIMULATION file 