`timescale 1ns / 1ps




module a15_274_H_Index();

class solutions;

    function int hIndex(input int citations[$]);
        
        int h;
        int min_idx;
        int h_arr[];
        int papers;
        
        h = citations.size();    // length named "h" becuase this is the limiting factor of h-index
        h_arr = new[h+1];
        h_arr = '{default:0};
        
        
        foreach(citations[i]) begin
            min_idx = citations[i] < h ? citations[i] : h;
            h_arr[min_idx] += 1;        
        end
    
        papers = h_arr[h];          // Papers represents the no of papers over a particular h index value
        
        while (h > papers) begin
            h--;
            papers += h_arr[h];
        end
        
        return h;
        
    endfunction
    
    function int hIndex1(input int citations[$]);
            int n;
            int count[];  
            int total;   
                   
            n = citations.size();
            count = new[n+1];  // Bucket for counting
            
            // Initialize count array
            foreach (count[i]) count[i] = 0;
            
            // Bucket sort - count papers per citation count
            foreach (citations[i]) begin
                if (citations[i] >= n) begin
                    count[n]++;
                end else begin
                    count[citations[i]]++;
                end
            end
            
            // Calculate H-index by accumulating from highest citations
            total = 0;
            for (int i = n; i >= 0; i--) begin
                total += count[i];
                if (total >= i) begin
                    return i;
                end
            end
            
            return 0;
        endfunction

endclass


    initial begin
        solutions solver = new();
        
        typedef struct {
            int citations[$];
            int expected_h;
        } test_case_t;
        
        test_case_t test_cases[$] = '{
            '{'{3,0,6,1,5}, 3},     // Standard case
            '{'{1,3,1}, 1},          // Basic case
            '{'{100}, 1},             // Single highly cited paper
            '{'{0,0,0}, 0},          // No citations
            '{'{4,4,4,4}, 4},        // All papers highly cited
            '{'{1,4,5,6,7}, 4}       // Mixed citations
        };
    
        foreach (test_cases[i]) begin
            // Local variable declarations
            int citations[$] = test_cases[i].citations;
            int expected_h = test_cases[i].expected_h;
            int h, h1;
            string pass;
            
            // Function call
            h = solver.hIndex(citations);
            h1 = solver.hIndex1(citations);
            // Verification
            pass = (h == expected_h) ? "PASS" : "FAIL";
            
            // Standardized output format
            $display("Input citations -> %p \nExpected H-index: %0d \nActual   H-index: %0d \nActual   H-index: %0d \nResult -> %4s \n\n",
                     citations,
                     expected_h,
                     h,
                     h1,
                     pass);
        end
    
        #10 $finish;
    end

endmodule