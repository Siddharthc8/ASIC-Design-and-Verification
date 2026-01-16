`timescale 1ns / 1ps




module a34_15_3Sum();
    
    
    typedef int ret [$];
    
    function ret threesum(input int nums[$]);
    
        int map [int];
        int res[$];
        int l;
        
        l = nums.size();
        
        foreach(nums[i]) begin
            map[nums[i]] = i;
        end
        
        $display("%p", map);
        return res;
    endfunction
    
    
    initial begin
        automatic int test[$] = '{-1,0,1,2,-1,-4};
        
        threesum(test);
    end

endmodule