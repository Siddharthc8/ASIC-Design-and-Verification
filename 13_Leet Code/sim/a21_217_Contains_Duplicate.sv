`timescale 1ns / 1ps




module a21_217_Contains_Duplicate();

typedef int ret_type;

class solutions;

    function ret_type containsDuplicate(input int nums[$]);
    
        int map[int];  // set behavior
        
        foreach(nums[i]) begin
            map[nums[i]] = 1;    
        end
        
        return ( nums.size() == map.size() ) ?  0 : 1;  // $size(map) and map.size() both work with associative array
        
    endfunction
    
    function ret_type containsDuplicate1(input int nums[$]);
    
        int map[int];  // set behavior
        
        foreach(nums[i]) begin
            if (map.exists(nums[i])) return 1;
            else map[nums[i]] = 1;    
        end
        
        return 0;  
    endfunction

endclass

    initial begin
        automatic solutions solver = new();

        // Test-case structure: input array and expected flag
        typedef struct {
            int  nums[];
            bit  expected;
        } test_case_t;

        // Test vectors including edge cases
        test_case_t test_cases[$] = '{
            '{'{1,2,3,1},      1},  // duplicate 1
            '{'{1,2,3,4},      0},  // no duplicate
            '{'{},             0},  // empty
            '{'{2,2,2,2},      1},  // all same
            '{'{99,-1,0,99},   1}   // duplicate 99
        };

        foreach (test_cases[i]) begin
            // Declarations before assignments
            int      nums[]  = test_cases[i].nums;
            bit      exp     = test_cases[i].expected;
            ret_type result;
            string   pass;

            // Invocation
            result = solver.containsDuplicate(nums);
            pass   = (result === exp) ? "PASS" : "FAIL";

            // Standardized output
            $display("Nums -> %p \nExpected duplicate: %0d \nActual   duplicate: %0d \nResult -> %4s \n\n",
                     nums,
                     exp,
                     result,
                     pass);
        end

        #10 $finish;
    end


endmodule