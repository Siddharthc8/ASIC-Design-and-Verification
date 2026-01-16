`timescale 1ns / 1ps




module a10_88_Merge_Sorted_Array();

    class solutions;
        
        typedef int res[$];
        
        function res merge(input int nums1[$], input int m, input int nums2[$], input int n);
        
            int i = m-1;
            int j = n-1;
            int k = m+n -1;
            
            while ( j>= 0) begin              
                if((nums1[i] > nums2[j]) && (i>=0)) begin             // Changin in-place ebut returning just to stay aware of returning methods and combinations of arrays and queue
                    nums1[k] = nums1[i];
                    i--;
                end
                else begin
                    nums1[k] = nums2[j];
                    j--;
                end
                
                k--;
            end
            
            return nums1;
        endfunction
    
    endclass
    
    
    
     initial begin
     
    solutions solver = new();
    
    // Test case structure
    typedef struct {
      int nums1[$];
      int m;
      int nums2[$];
      int n;
      int expected[$];

    } test_case_t;
    
    automatic test_case_t test_cases[$] = '{
      // nums1 (with padding), m, nums2, n, expected
      '{'{1,2,3,0,0,0}, 3, '{2,5,6}, 3, '{1,2,2,3,5,6}},
      '{'{1}, 1, '{}, 0, '{1,0}},
      '{'{0}, 0, '{1}, 1, '{1}},
      '{'{4,5,6,0,0,0}, 3, '{1,2,3}, 3, '{1,2,3,4,5,6}}
    };

    $display("| Test Case               | Merged Result       | Pass |");
    $display("|-------------------------|--------------------|------|");

    foreach (test_cases[i]) begin
    
            int nums1[$];
            int nums2[$];
            int m,n;
            int expected[$];
            int res[$];
            bit pass;
            
            // assigned after decalration to avoid erros. Vivado throws an error when decalreed and assigned together
            nums1 = test_cases[i].nums1;
            nums2 = test_cases[i].nums2;
            m = test_cases[i].m;
            n = test_cases[i].n;
            expected = test_cases[i].expected;
            

            // Perform merge
            res = solver.merge(nums1, m, nums2, n);
            
            // Check result (only compare relevant elements)
            for (int idx = 0; idx < expected.size(); idx++) begin
                if (res[idx] !== expected[idx]) begin
                    pass = 0;
                    break;
                end else begin
                    pass = 1;
                end
            end
            
            $display("| nums1=%p m=%0d nums2=%p n=%0d | %-18p | %4s |", 
                   nums1[0:m-1],
                   m,
                   nums2,
                   n,
                   nums1[0:m+n-1],
                   pass ? "PASS" : "FAIL");
        end

    
    end
    
    initial begin
        #10 $finish;
    end
  
  
endmodule