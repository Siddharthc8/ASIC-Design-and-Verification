`timescale 1ns / 1ps




module a13_75_Sort_Colors();
    
    typedef int ret_type[$];
    
    class solutions;
    
        
        function ret_type sortColors(input int nums[$]);
        
            int L = 0;
            int R = nums.size()-1;
            int i = 0;
            int temp;
            
            while (i <= R) begin
                
                if(nums[i] == 0) begin
                    temp = nums[i];
                    nums[i] = nums[L];
                    nums[L] = temp;
                    L++;
                end else if(nums[i] == 2) begin
                    temp = nums[i];
                    nums[i] = nums[R];
                    nums[R] = temp;
                    R--;
                    i--;
                end
            i++;    // The reason why it is not declared inside first if vlovk is to accomodate for when nums[i] == 1
            end
        
            return nums;
        
        endfunction
        
        
//         Helper function
        function void swap(ref int i,ref int j); 
            int temp;
            
            temp = i;
            i = j;
            j = temp;
//            temp = nums[i];
//            nums[i] = nums[j];
//            nums[j] = temp;
        endfunction
        
        // Interesting case statement method
        function ret_type sortColors1(input int nums[$]);
            
            int L = 0;
            int i = 0;
            int R = nums.size() -1;
            
            while( i <= R) begin
            
                case(nums[i])
                    
                    0 : begin 
                        swap(nums[i], nums[L]);
                        L++;
                        i++;
                    end
                    
                    1 : i++;
                    
                    2 : begin
                        swap(nums[i], nums[R]);
                        R--;
                    end
                endcase
            
            end
            
        return nums;
        
        endfunction
    
    endclass
    
    
    initial begin
        solutions solver = new();
        
        typedef struct {
            int nums[$];
            int expected_nums[$];
        } test_case_t;
        
        test_case_t test_cases[$] = '{
            '{'{2,0,2,1,1,0}, '{0,0,1,1,2,2}},
            '{'{2,0,1}, '{0,1,2}},
            '{'{0}, '{0}},
            '{'{1}, '{1}},
            '{'{1,2,0}, '{0,1,2}},
            '{'{1,1,1}, '{1,1,1}}
        };
    
        foreach (test_cases[i]) begin
            int nums[$] = test_cases[i].nums;
            int expected_nums[$] = test_cases[i].expected_nums;
            ret_type res, res1;
            string pass;
            
            res = solver.sortColors(nums);
            res1 = solver.sortColors1(nums);
            
            pass = (res == expected_nums) ? "PASS" : "FAIL";
            
            $display("Original nums -> %p \nExpected arr: %p \nActual1  arr: %p \nActual2  arr: %p \nResult -> %4s \n\n",
                     nums,
                     expected_nums,
                     res,
                     res1,
                     pass);
        end
    
    end
    
    initial begin
        #10 $finish;
    end
    

endmodule