`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2025 08:48:07 AM
// Design Name: 
// Module Name: a100_191_Number_of_1_Bits
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


module a100_191_Number_of_1_Bits();



class solutions;

    function int count_ones_bruteforce(logic [31:0] nums);
        logic [5:0] count;
        
        for(int i = 0; i< 32; i++) begin
        
            if (nums[i]) count++;
        end
        
        return count;
    endfunction
    
    
    
    function int count_ones_kernighan(logic [31:0] nums);  // automatic ensures each function call gets it own count and temp variable
        int count;
        logic [31:0] temp = nums;
         
        while (temp != 0) begin
            
            temp = temp & temp - 1;
            count ++;
        
        end
        
        return count;
    endfunction

endclass

    
    initial begin
    solutions bc = new();  // Create class instance
    logic [31:0] test_nums[6] = '{
      32'h00000000,  // 0 bits
      32'hFFFFFFFF,  // 32 bits
      32'hA5A5A5A5,  // 16 bits (1010 pattern)
      32'h0000000F,  // 4 bits
      32'h80000001,  // 2 bits
      32'h12345678   // 13 bits
    };

    // Print results
    $display("| Number (Hex) | Brute-Force | Kernighan | Kernighan2 |");
    $display("|--------------|-------------|-----------|------------|");

    foreach (test_nums[i]) begin
      int bf = bc.count_ones_bruteforce(test_nums[i]);
      int kg = bc.count_ones_kernighan(test_nums[i]);
      int kg1 = bc.count_ones_kernighan(test_nums[i]);
      $display("| %8h      | %2d         | %2d       |%2d       |", 
               test_nums[i], bf, kg, kg1);
    end

    #10 $finish;
  end
    
    
    
endmodule
