`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2025 11:31:13 AM
// Design Name: 
// Module Name: tb_merge_sort
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


module tb_merge_sort();


class solutions;
    typedef int ret_type[$];

    // Merge two sorted arrays
    function ret_type merge(ret_type left, ret_type right);
        ret_type merged = {};
        int i = 0, j = 0;

        // Merge elements from left and right in order
        while (i < left.size() && j < right.size()) begin
            if (left[i] < right[j]) begin
                merged.push_back(left[i]);
                i++;
            end else begin
                merged.push_back(right[j]);
                j++;
            end
        end

        // Append any remaining elements from left
        while (i < left.size()) begin
            merged.push_back(left[i]);
            i++;
        end
        // Append any remaining elements from right
        while (j < right.size()) begin
            merged.push_back(right[j]);
            j++;
        end
        return merged;
    endfunction

    // Recursive merge sort
    function ret_type merge_sort(input ret_type arr);
        
        int mid;
        ret_type left;
        ret_type right;
        ret_type res;
        
        if (arr.size() == 1)
            return arr;
            
        mid = arr.size() / 2;
        left = arr[0 : mid-1];
        right = arr[mid : arr.size()-1];

        left = merge_sort(left);
        right = merge_sort(right);
        
        res = merge(left, right);
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
    
            result = solver.merge_sort(arr); // Call your merge sort function
    
            pass = (result == expected) ? "PASS" : "FAIL";
    
            $display("Input array     -> %p\nExpected sorted -> %p\nActual   sorted -> %p\nResult -> %4s\n",
                     arr, expected, result, pass);
        end
    
        #10 $finish;
    end



endmodule
