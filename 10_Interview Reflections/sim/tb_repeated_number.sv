`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2025 12:40:38 PM
// Design Name: 
// Module Name: tb_repeated_number
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


module tb_repeated_number();


  int arr[] = '{0, 2, 1, 3, 4, 2, 5}; // 2 is repeated
  int found = -1;
  int map[int];

  initial begin
    foreach (arr[i]) begin
      if (map.exists(arr[i])) begin
        found = arr[i];
        break;
      end
      map[arr[i]] = 1;
    end
    $display("First repeated = %0d", found);
  end
  
  
  
  module tb;
  int arr[] = '{1,2,2,3,1,4};
  int seen[int];
  int out[$];
  initial begin
    foreach (arr[i])
      if (!seen.exists(arr[i])) begin
        seen[arr[i]] = 1;
        out.push_back(arr[i]);
      end
    $display("Unique: %p", out); // Output: '{1,2,3,4}
  end
endmodule




endmodule
