`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2025 01:09:38 PM
// Design Name: 
// Module Name: tb_merge_sort_prac
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


module tb_merge_sort_prac();

    typedef int ret_type[$];
    
class solutions;

    function ret_type mergeSort(input ret_type nums);
        
        int mid;
        int i,j;
        ret_type left, right;
        ret_type res;
        
        if(nums.size <= 1) return nums;
        
        mid = nums.size()/2;
        left = nums[0 : mid-1];
        right = nums[ mid : nums.size()-1];
        
        left = mergeSort(left);
        right = mergeSort(right);
        
        i = 0;
        j = 0;

        while( i < left.size() && j < right.size() ) begin
            if(left[i] < right[j]) begin
                res.push_back(left[i]);
                i++;
            end
            else begin
                res.push_back(right[j]);
                j++;
            end
        end
        
        
        while( i < left.size()) begin
            res.push_back(left[i]);
            i++;
        end
        
        while( j < right.size()) begin
            res.push_back(right[j]);
            j++;
        end

        
        return res;
        
    endfunction
    
endclass



    initial begin
        solutions solver = new();
    
        typedef struct {
            int arr[$];      // Input array
            int expected[$]; // Expected sorted result
        } test_case_t;
    
        test_case_t test_cases[$] = '{
            // Already sorted
            '{ '{1, 2, 3, 4, 5}, '{1, 2, 3, 4, 5} },
    
            // Reverse sorted
            '{ '{5, 4, 3, 2, 1}, '{1, 2, 3, 4, 5} },
    
            // Random order
            '{ '{10, 1, 5, 7, 3}, '{1, 3, 5, 7, 10} },
    
            // With duplicates
            '{ '{2, 3, 2, 1, 4}, '{1, 2, 2, 3, 4} },
    
            // All elements same
            '{ '{3, 3, 3, 3}, '{3, 3, 3, 3} },
    
            // Single element
            '{ '{7}, '{7} }
    
            // Empty array
//            '{ '{} , '{}' }
        };
    
        foreach (test_cases[i]) begin
            int arr[$] = test_cases[i].arr;
            int expected[$] = test_cases[i].expected;
            int result[$];
            string pass;
    
            result = solver.mergeSort(arr); // Call your merge sort function
    
            pass = (result == expected) ? "PASS" : "FAIL";
    
            $display("Input array     -> %p\nExpected sorted -> %p\nActual   sorted -> %p\nResult -> %4s\n",
                     arr, expected, result, pass);
        end
    
        #10 $finish;
        
    end
    
    
endmodule
