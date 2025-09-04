`timescale 1ns / 1ps

module tb_array_filtering_methods();
    
    int arr[] = '{1, 2, 2, 3, 4, 4, 5, 6, 6, 7, 9};
    int result[$];
    int first[$], last[$];
    
    initial begin
        // 1. find() - returns queue of matching elements
        result = arr.find with (item > 3);
        $display("find(>3): %p", result);  // '{4,4,5,6,6,7,9}
        
        // 2. find_first() - queue with first match
        first = arr.find_first with (item % 2 == 0);
        $display("find_first(even): %p", first);   // '{2}
        $display("find_first(even) scalar: %0d", first[0]); // 2
        
        // 3. find_last() - queue with last match
        last = arr.find_last with (item < 5);
        $display("find_last(<5): %p", last);   // '{4}
        $display("find_last(<5) scalar: %0d", last[0]); // 4
        
        // 4. unique()
        result = arr.unique();
        $display("unique(): %p", result);  // '{1,2,3,4,5,6,7,9}
        
        // 5. min()/max()/sum()
        $display("min: %0d, max: %0d, sum: %0d", 
                 arr.min(), arr.max(), arr.sum());  // 1,9,49
        
        // 6. sort()/reverse()
        arr.reverse();
        $display("reversed: %p", arr);  // '{9,7,6,6,5,4,4,3,2,2,1}
        arr.sort();
        $display("sorted: %p", arr);    // '{1,2,2,3,4,4,5,6,6,7,9}
    end

endmodule
