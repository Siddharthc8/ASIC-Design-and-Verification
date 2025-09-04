`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2025 07:05:47 PM
// Design Name: 
// Module Name: tb_array_with_queue
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


module tb_array_with_queue();

/* 
 Understanding int test_cases[4][$]
1) [4] (First Dimension):

A fixed-size array with exactly 4 elements (indexes 0 to 3).

Each element is a queue of integers.

2) [$] (Second Dimension):

A dynamic queue (size can grow/shrink at runtime).

Each queue holds integers (int) */


int test_cases [4][$] = '{                        // Array length ie 4 is fixed but each array length inside is not fixed
  '{-2, -1, 1, 2},      // Queue 0 (4 elements)
  '{-4, -2, 1, 4, 8},   // Queue 1 (5 elements)
  '{2, -1, 1},          // Queue 2 (3 elements)
  '{-100, -50, 0, 50}   // Queue 3 (4 elements)
};



int test_cases1 [$][5] = '{                        // Array length ie unlimited  but each array length inside can hold 5 values
  '{-2, -1, 1, 2},      // Queue 0 (4 elements)
  '{-4, -2, 1, 4, 8},   // Queue 1 (5 elements)
  '{2, -1, 1},          // Queue 2 (3 elements)
  '{-100, -50, 0, 50}   // Queue 3 (4 elements)
};





endmodule
