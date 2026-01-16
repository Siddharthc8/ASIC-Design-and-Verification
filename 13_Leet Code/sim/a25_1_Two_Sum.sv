`timescale 1ns / 1ps




module a25_1_Two_Sum();


        typedef int ret_type[$];
    
class solutions;
    
    
    function ret_type bruteForce(input int nums[$], input int target);
        
        int n;
        
        n = nums.size();
        
        for(int i=0;i<n;i++) begin
            for(int j=i+1;j<n;j++) begin
                if(nums[i] + nums[j] == target) return {i,j};
            end
        end
        
    endfunction
    
    
    function ret_type twoSum(input int nums[$], input int target);
        
        int map[int];
        int sub;
        int res[$];
        int n = nums.size();
        
        
        for(int j = 0; j < n; j++)begin
            sub = target - nums[j];
            if(map.exists(sub)) begin
                res = {map[sub], j};   // Since the index is not already aded we have to use the sub_target index first followed by j
                return res;
            end 
            else begin
                map[nums[j]] = j;
            end
            
        end
    
    endfunction
    
    
    function ret_type gregg(input int nums[$], input int target);
        
        int map[int];
        int sub;
        int res[$];
        int n = nums.size();
        
        for(int i = 0; i< n; i++) begin
            map[nums[i]] = i;
        end
        
        for(int j = 0; j < n; j++)begin
            sub = target - nums[j];
            if(map.exists(sub) && map[sub] != j) begin
                res = {j, map[sub]};   // Since the index is already added we have to use j first followed by the sub_target index 
                return res;
            end 
            
        end
    
    endfunction
    

endclass


    initial begin
        solutions solver = new();
        
        typedef struct {
            int nums[$];
            int target;
            int expected_indices[$];
        } test_case_t;
        
        test_case_t test_cases[$] = '{
            '{'{2,7,11,15}, 9, '{0,1}},
            '{'{3,2,4}, 6, '{1,2}},
            '{'{3,3}, 6, '{0,1}},
            '{'{1,2,3,4}, 10, '{}}  // No solution case
        };
    
        foreach (test_cases[i]) begin
            int nums[$] = test_cases[i].nums;
            int target = test_cases[i].target;
            int expected_indices[$] = test_cases[i].expected_indices;
            ret_type res;
            string pass;
            
            res = solver.twoSum(nums, target);
            
            pass = (res == expected_indices) ? "PASS" : "FAIL";
            
            $display("Input nums -> %p | Target: %0d \nExpected indices: %p \nActual   indices: %p \nResult -> %4s \n\n",
                     nums,
                     target,
                     expected_indices,
                     res,
                     pass);
        end
    
        #10 $finish;
    end

endmodule

