`timescale 1ns / 1ps




module a11_122_Best_Time_to_Buy_and_Sell_Stock_II();
    
    class solutions;
        
        function int maxProfit(input int prices[$]);
            
            int prev;
            int curr;
            int profit = 0;
            int total_profit = 0;
            int buy = prices[0];

            for(int i = 1; i < prices.size(); i++) begin
                
                curr = prices[i];
                prev = prices[i-1];
                
                if(curr >= prev) begin
                    profit = curr - buy;
                end
                
                else begin
                    total_profit += profit;
                    buy = curr;
                    profit = 0;
                
                end  
            
            end
            
            total_profit += profit;
            return total_profit;
        
        endfunction
        
        
       // Simplest logic but may not be thinkable in an interview
       function int maxProfit1(input int prices[$]);
          int profit = 0;
          for (int i = 1; i < prices.size(); i++) begin
            if (prices[i] > prices[i-1]) begin
              profit += prices[i] - prices[i-1];
            end
          end
          return profit;
      endfunction

    
    endclass
    
    
    initial begin
    
        solutions solver = new();
        
        // Test case structure
        typedef struct {
          int prices[$];
          int expected;
        } test_case_t;
        
        test_case_t test_cases[$] = '{
          '{'{7,1,5,3,6,4}, 7},  // Buy@1, Sell@5, Buy@3, Sell@6
          '{'{1,2,3,4,5}, 4},      // Buy@1, Sell@5
          '{'{7,6,4,3,1}, 0},      // No transactions
          '{'{2,1,4}, 3},          // Buy@1, Sell@4
          '{'{3,3,5,0,0,3,1,4}, 8} // Multiple transactions
        };
    
        $display("| Prices            | Max Profit | Pass |");
        $display("|-------------------|------------|------|");
    
        foreach (test_cases[i]) begin
          int profit = solver.maxProfit(test_cases[i].prices);
          string pass = (profit == test_cases[i].expected) ? "PASS" : "FAIL";
          
          $display("| %-17p | %4d       | %4s |", 
                   test_cases[i].prices, 
                   profit,
                   pass);
        end

        #10 $finish;
    end

endmodule