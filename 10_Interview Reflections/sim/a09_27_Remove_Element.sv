`timescale 1ns / 1ps

 


module a09_27_Remove_Element();

class solutions;
    // Method 1: Two-pointer in-place removal (optimal)
    function int removeElement(const ref int nums[$],input  int val);
    
      int k = 0;
      int temp1[$];
      temp1 = nums;
      
      foreach (temp1[i]) begin
        if (temp1[i] != val) temp1[k++] = temp1[i];
      end
      temp1 = temp1[0:k-1];  // Truncate the queue
      
      return k;
      
    endfunction
//------------------------------------------------------
    // Method 2: Alternative approach using queue operations
    function int removeElementAlt(const ref int nums[$],input  int val);

      int temp2[$];
      temp2 = nums;
      for (int i = temp2.size()-1; i >= 0; i--) begin
        if (temp2[i] == val) begin
          temp2.delete(i);
        end
      end
      
      return temp2.size();
      
    endfunction
//-------------------------------------------------------
    // Method 3: Returning a queue type of the resultant nums
        typedef int int_q[$];
    
    function int_q removeElement2(const ref int nums[$], int targ);
        
        int res[$];
        
        for(int i = 0; i < nums.size(); i++) begin
            if(nums[i] != targ) 
                res.push_back(nums[i]);
        end
        /*
        foreach(nums[i]) begin
            if(nums[i] != targ) res.push_back(nums[i]);
        end
        */
    return res;
    endfunction
    
    
  endclass

//---------------------------------------------------------------------------------
    
  initial begin
    solutions solver = new();

    // Test case structure
    typedef struct {
      int nums[$];
      int val;
    } test_case_t;
    
    test_case_t test_cases[$] = '{
      '{'{3,2,2,3}, 3},          // Standard case
      '{'{0,1,2,2,3,0,4,2}, 2}, // Multiple occurrences
      '{'{}, 5},                     // Empty array
      '{'{5,5,5,5}, 5},              // All elements equal val
      '{'{1,3,3,3,3,3}, 1},                     // Single element equal val
      '{'{4,5}, 4}                  // Single element not equal val
    };

    $display("| Method 1 (k) | Method 2 (k) | Method 3 (k) | Test Case |-> Val |");
    $display("|--------------|--------------|--------------|-----------|-> -----|");

    foreach (test_cases[i]) begin
      
      int val;
      int test_case[$];
      int k1,k2;
      int  k3[$];
      
      test_case = test_cases[i].nums;
      val = test_cases[i].val;
      
      k1 = solver.removeElement(test_case, val);
      k2 = solver.removeElementAlt(test_case, val);
      k3 = solver.removeElement2(test_case, val);
      
//      string pass = (k1 == test_cases[i].expected_k) ? "PASS" : "FAIL";
      
      $display("| %4d         | %4d         |%p         | %p  %0d | ",
               k1, k2, k3, test_case, val);
    end

    #10 $finish;
  end


endmodule

