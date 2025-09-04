`timescale 1ns / 1ps




module a16_56_Merge_Intervals();
    
    
    typedef int ret_type[$][2];
class solutions;
    
    function ret_type merge(input int intervals[$][2]);
        
        int n;
        int size;
        int start;
        int ends;
        int max;
        ret_type res;
//        ret_type intervals;
        
        start = 0;
        ends = 1;
        n = intervals.size();
        
//        sort_me(intervals);
        intervals.sort() with (item[0]);        
        
        foreach(intervals[i]) begin
            size = res.size();
            if(res.size() == 0 || res[size-1][ends] < intervals[i][start] ) begin
                res.push_back(intervals[i]);
            end 
            else begin
                max = res[size-1][ends] > intervals[i][ends] ? res[size-1][ends] : intervals[i][ends];    // Using intermediate value for max value calc to increase readability
                res[size-1][ends] = max; 
            end
             
        end
        
        return res;
        
    endfunction
    
    
    
    function ret_type merge1(input int intervals[$][2]);
        
        
    
    endfunction
    
    
    
    function void sort_me(ref int nums[$][2]);
        
        int n;
        n = nums.size();
        
        for(int i = 0; i < n; i++) begin
            for(int j = 0; j < n-1-i; j++) begin
                if(nums[j][0] > nums[j+1][0]) begin
                    int temp[2];  // OR     // int temp[];
                                            // temp = new[2];
                    temp = nums[j];
                    nums[j] = nums[j+1];
                    nums[j+1] = temp;
                end
            end
        end 
    
    endfunction

endclass


    initial begin
        solutions solver = new();
        
        typedef struct {
            int intervals[$][2];
            int expected[$][2];
        } test_case_t;
        
        test_case_t test_cases[$] = '{
            // Standard cases
            '{'{{1,3},{2,6},{8,10},{15,18}}, '{{1,6},{8,10},{15,18}}},
            '{'{{1,4},{4,5}}, '{{1,5}}},
            
            // Edge cases
            '{'{{1,4},{2,3}}, '{{1,4}}},
            '{'{{1,4},{5,6}}, '{{1,4},{5,6}}},
            '{'{{15,18},{8,10},{2,6},{1,3}}, '{{1,6},{8,10},{15,18}}},
            '{'{{1,4}}, '{{1,4}}}
        };
    
        foreach (test_cases[i]) begin
            // Local variable declarations
            int intervals[$][2] = test_cases[i].intervals;
            int expected[$][2] = test_cases[i].expected;
            ret_type result;
            string pass;
            
            // Function call
            result = solver.merge(intervals);
            
            // Verification
            pass = (result == expected) ? "PASS" : "FAIL";
            
            // Standardized output format
            $display("Input intervals -> %p \nExpected merged: %p \nActual   merged: %p \nResult -> %4s \n\n",
                     intervals,
                     expected,
                     result,
                     pass);
        end
    
        #10 $finish;
    end
    
    
endmodule


