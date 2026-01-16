`timescale 1ns / 1ps




module a08_26_Remove_Duplicates_from_Sorted_Array();

class Solutions;
    

  function int removeDuplicates(int nums[$]);
  
        int j = 1; // In-place removal
        if (nums.size() == 0) return 0; // Handle empty array
        
        for (int i = 1; i < nums.size(); i++) begin
            if (nums[i] != nums[i-1]) begin
                nums[j] = nums[i]; //  ---OR  nums[j++] = nums[i];
                j++;               // ----OR
            end
        end
        return j; // Length of unique elements
    endfunction
    
    //-----------------------------------------------------_
    
    typedef int int_q[$];
    
    function int_q removeDuplicates1(int nums[$]);
        
        int res[$];
        
        if(nums.size() != 0) res.push_back(nums[0]);
        
        foreach(nums[i]) begin
            if(nums[i] != nums[i-1] && i != 0) begin
                res.push_back(nums[i]);
            end
        end
        
        return res;
    endfunction

endclass
//----------------------------------

    initial begin
        
        Solutions sol = new();
        int test_cases[5][$] = '{
            '{1, 1, 2, 2, 3, 4, 4, 5}, // Test Case 1
            '{} ,                        // Test Case 2
            '{7},                        // Test Case 3
            '{2, 2, 2, 2, 2},           // Test Case 4
            '{1, 2, 3, 4, 5}            // Test Case 5
        };
        
        
        foreach (test_cases[i]) begin
            
            int k1;
            int k2[$];
            
            k1 = sol.removeDuplicates(test_cases[i]);
            k2 = sol.removeDuplicates1(test_cases[i]);

            $display("k1: %0d  |  k2: %p | Input: %p", k1, k2, test_cases[i]);

        end
    end

  
endmodule