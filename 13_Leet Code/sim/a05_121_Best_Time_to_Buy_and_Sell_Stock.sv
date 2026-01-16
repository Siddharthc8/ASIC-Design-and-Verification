`timescale 1ns / 1ps




module a05_121_Best_Time_to_Buy_and_Sell_Stock();

class Solutions;

    function automatic int maxProfit(int prices[$]);
    
    int min_price, max_profit;
      if (prices.size() < 2) return 0;
      
      min_price = prices[0];
      max_profit = 0;
      
      foreach (prices[i]) begin
        if (prices[i] < min_price) begin
          min_price = prices[i];
        end else if (prices[i] - min_price > max_profit) begin
          max_profit = prices[i] - min_price;
        end
      end
      
      return max_profit;
    endfunction

    function automatic int Python_style(input int nums[$]);
    
        int max_profit = 0;
        int min_price;
        
        if (nums.size() != 0) min_price = nums[0];
        else return 0;
        
        for (int i = 0; i < nums.size(); i++) begin
            
            min_price = nums[i] < min_price ? nums[i] : min_price;
            max_profit = max_profit > nums[i]-min_price ? max_profit : nums[i]-min_price;
        
        end
        
        return max_profit;
        
    endfunction
    
    
    function automatic int two_pointers(input int nums[$]);
    
    int L = 0;
    int R = 1;
    int max_profit = 0;
    
    while (R < nums.size()) begin
    
        int buy_price = nums[L];
        int curr_price = nums[R];
        
        if (buy_price < curr_price) 
            max_profit = max_profit > curr_price-buy_price ? max_profit : curr_price-buy_price;
        else
            L = R;  // <<----- Careful interchanging this could cause indefinite hang for certain test cases
        R++;
    
    end    
    
    return max_profit;
    
    endfunction


endclass
    
    initial begin
    #100;
    $fatal("Timeout: Simulation did not complete in expected time.");;
    end

    initial begin
    Solutions solver = new();
    int test_cases[5][$] = '{
      '{7,1,5,3,6,4},  // Expected: 5 (buy@1, sell@6)
      '{7,6,4,3,1},    // Expected: 0 (no profit possible)
      '{3,2,6,5,0,3},  // Expected: 4 (buy@2, sell@6)
      '{1,2},          // Expected: 1 (buy@1, sell@2)
      '{5}             // Expected: 0 (single price)
    };

    $display("| Prices           | Max Profit |");
    $display("|------------------|------------|");

    foreach (test_cases[i]) begin
    int profit1, profit2, profit3;
    
      profit1 = solver.maxProfit(test_cases[i]);
      $display("| %p | %4d       |", test_cases[i], profit1);
      profit2 = solver.Python_style(test_cases[i]);
      $display("| %p | %4d       |", test_cases[i], profit2);
      profit3 = solver.two_pointers(test_cases[i]);
      $display("| %p | %4d       |", test_cases[i], profit3);
    end

    #10 $finish;
  end
    
    
    

endmodule