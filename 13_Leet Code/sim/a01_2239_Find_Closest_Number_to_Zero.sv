`timescale 1ns / 1ps




module a01_2239_Find_Closest_Number_to_Zero();

  class solutions;
  
  // Helper function
  function int abs(int num);
    if (num < 0) return -num; 
    else return num;
    // return (x<0) ? -x : x;
  endfunction
  
  
    // Method 1: Brute-Force (Check all numbers)
    function int find_closest_bruteforce(int nums[$]);
      int closest = nums[0];
      foreach (nums[i]) begin
        if (abs(nums[i]) < abs(closest)) 
          closest = nums[i];
        else if (abs(nums[i]) == abs(closest))
          closest = nums[i] > closest ? nums[i] : closest;
      end
      return closest;
    endfunction

    // Method 2: Optimized Single Pass
    function int find_closest_optimized(int nums[$]);
      int closest = nums[0];
      foreach (nums[i]) begin
        if (abs(nums[i]) < abs(closest)) 
          closest = nums[i];
        else if (abs(nums[i]) == abs(closest) && nums[i] > closest)
          closest = nums[i];
      end
      return closest; 
    endfunction


  endclass

  initial begin
    solutions solver = new();
    int test_cases[4][$] = '{
      '{-2, -1, 1, 2},      // Expected: 1
      '{-4, -2, 1, 4, 8},    // Expected: 1
      '{2, -1, 1},           // Expected: 1
      '{-100, -50, 0, 50}    // Expected: 0
    };

    $display("| Test Case       | Brute-Force | Optimized |");
    $display("|-----------------|-------------|-----------|");

    foreach (test_cases[i]) begin
      int bf = solver.find_closest_bruteforce(test_cases[i]);
      int opt = solver.find_closest_optimized(test_cases[i]);
      $display("| %p | %4d        | %4d      |",       
               test_cases[i], bf, opt); 
    end

    #10 $finish;
  end


endmodule

