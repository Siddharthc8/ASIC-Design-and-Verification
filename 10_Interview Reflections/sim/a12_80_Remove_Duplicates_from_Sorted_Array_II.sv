`timescale 1ns / 1ps




module a12_80_Remove_Duplicates_from_Sorted_Array_II();
    
    
        typedef struct {
            int nums[$];
            int n;
        } ret_type;
        
        
    class solutions;
       
        typedef ret_type res;
        
        function res removeDuplicates(input int nums[$]);
        
            int count  = 1;
            int curr, prev;
            int  k = 1;
            int temp[$];
                       
            for(int i = 1; i < nums.size(); i++) begin
            
                 curr = nums[i];
                 prev = nums[i-1];
                 
                 if ( curr != prev) begin
                    nums[k++] = curr;
                    count  = 1;
                 end
                 else if (curr == prev && count < 2) begin
                    nums[k++] = curr;
                    count++;
                 end
                    
            end 
//            $display("%p", nums[0:k-1]);
            return { nums[0:k-1], k };
        endfunction
        
        
     endclass
        
        
        initial begin
        
            solutions solver = new();
            
            typedef struct {
              int nums[$];
              int expected_k;
              int expected_nums[$];
            } test_case_t;
            
            test_case_t test_cases[$] = '{
              '{'{1,1,1,2,2,3}, 5, '{1,1,2,2,3}},
              '{'{0,0,1,1,1,1,2,3,3}, 7, '{0,0,1,1,2,3,3}},
              '{'{1,2,3}, 3, '{1,2,3}},
              '{'{}, 0, '{}},
              '{'{1,1}, 2, '{1,1}},
              '{'{1,1,1,1}, 2, '{1,1}}
            };
        
        
            foreach (test_cases[i]) begin
            
              // Local copies using struct names directly
              int nums[$] = test_cases[i].nums;
              int expected_k = test_cases[i].expected_k;
              int expected_nums[$] = test_cases[i].expected_nums;
              ret_type res;
              string pass;
              
              // Operation (works on local copy)
              res = solver.removeDuplicates(nums);
              
              // Verification
              pass = (res.nums == expected_nums && res.n == expected_k) ? "PASS" : "FAIL";
              
              $display("Original nums -> %p \nExpected arr: %p|  Expected length: %d \nActual   arr: %p|  Actual   length: %d  \nResult -> %4s \n\n",
                       nums,  // Original test case values
                       expected_nums,                   // Result length
                       expected_k,                // Modified array
                       res.nums,
                       res.n,
                       pass);
            end
        
            #10 $finish;
        end
    

endmodule