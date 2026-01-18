`timescale 1ns / 1ps




module a14_238_Product_of_Array_Except_Self();

typedef int ret_type[$];

class solutions;
    
    function ret_type productExceptSelf(input int nums[$]);
        

        int n;
        int pre = 1;
        int post = 1;
        int res[];
        
        n = nums.size();
        res = new[n];        // Using dynamic array since we need to assign values to a predefined length of values
        
//        foreach(res[i]) res[i] = 1;
        res = '{default: 1};
        
        for(int i=0; i< n; i++) begin
            
            res[i] *= pre;
            pre *= nums[i]; 
            
            res[n-1-i] *= post;
            post *= nums[n-1-i];
        
        end 
    
    return res;
    
    endfunction

endclass


    initial begin
        solutions solver = new();
        
        typedef struct {
            int nums[$];
            int expected_products[$];
        } test_case_t;
        
        test_case_t test_cases[$] = '{
            '{'{1,2,3,4}, '{24,12,8,6}},
            '{'{-1,1,0,-3,3}, '{0,0,9,0,0}},
            '{'{5}, '{1}},
            '{'{2,3}, '{3,2}},
            '{'{-2,-3,-4}, '{12,8,6}}
        };
    
        foreach (test_cases[i]) begin
            int nums[$] = test_cases[i].nums;
            int expected_products[$] = test_cases[i].expected_products;
            ret_type res;
            string pass;
            
            res = solver.productExceptSelf(nums);
            
            pass = (res == expected_products) ? "PASS" : "FAIL";
            
            $display("Input nums -> %p \nExpected products: %p \nActual   products: %p \nResult -> %4s \n\n",
                     nums,
                     expected_products,
                     res,
                     pass);
        end
    
        #10 $finish;
    end

endmodule


