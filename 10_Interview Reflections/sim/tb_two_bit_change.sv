`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2025 01:22:05 AM
// Design Name: 
// Module Name: tb_two_bit_change
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_two_bit_change();

    class two_bit_flip;
      rand bit [31:0] value;
      bit [31:0] prev_value;
    
      // Constraint: exactly 2 bits must differ between prev_value and value
      constraint two_flip {
        $countones(value ^ prev_value) == 2;
      }
    
      // Save current value before randomization
      function void pre_randomize();
        // If first time, prev_value could be set to value or 0 or random as needed
        // Here, just keep previous value by default
      endfunction   

      // Update prev_value after randomization
      function void post_randomize();
        prev_value = value;
      endfunction
endclass


  two_bit_flip obj = new();

  initial begin
    obj.prev_value = 32'h0; // Initial value
    repeat (10) begin
      assert(obj.randomize());
      $display("Value: %h, Prev: %h, Flipped: %0d", obj.value, obj.prev_value, $countones(obj.value ^ obj.prev_value));
    end
  end
endmodule

