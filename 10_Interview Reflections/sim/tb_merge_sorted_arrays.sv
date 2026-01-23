`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2025 01:19:12 AM
// Design Name: 
// Module Name: tb_merge_sorted_arrays
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


module tb_merge_sorted_arrays();


  int A[] = '{1, 3, 5, 7};
  int B[] = '{2, 4, 6, 8, 9};
  int C[$]; // Queue for dynamic size

  initial begin
    int i = 0, j = 0;
    while (i < A.size() && j < B.size()) begin
      if (A[i] < B[j])
        C.push_back(A[i++]);
      else
        C.push_back(B[j++]);
    end
    while (i < A.size()) C.push_back(A[i++]);   // INTERESTING  //////
    while (j < B.size()) C.push_back(B[j++]);
    $display("Merged: %p", C);
  end
  
  
endmodule

