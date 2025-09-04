`timescale 1ns / 1ps




module a07_228_Summary_Ranges();
    
  class solutions;
    // Method: Generate summary ranges
    function string summaryRanges(int nums[$]);
      string result[$] = {};
      int n = nums.size();
      int i = 0;
      string output_str;
      
      while (i < n) begin
        int start = nums[i];
        while (i+1 < n && nums[i+1] == nums[i] + 1) begin
          i++;
        end
        if (start != nums[i]) begin
          result.push_back($sformatf("%0d->%0d", start, nums[i]));
        end else begin
          result.push_back($sformatf("%0d", start));
        end
        i++;
      end
      
      // Convert string queue to a single string for display
      output_str = "{";
      foreach (result[i]) begin
        output_str = {output_str, result[i]};
        if (i != result.size()-1) output_str = {output_str, ","};
      end
      output_str = {output_str, "}"};
      
      return output_str;
    endfunction
  endclass

  initial begin
    solutions solver = new();
    int test_cases[5][$] = '{
      '{0,1,2,4,5,7},    // Expected: {"0->2","4->5","7"}
      '{0,2,3,4,6,8,9},   // Expected: {"0","2->4","6","8->9"}
      '{},                 // Expected: {}
      '{-1},               // Expected: {"-1"}
      '{-2147483648,-2147483647,2147483647}  // Edge case
    };

    $display("| Input Array        | Summary Ranges          |");
    $display("|--------------------|-------------------------|");

    foreach (test_cases[i]) begin
      string result = solver.summaryRanges(test_cases[i]);
      $display("| %-18p | %-23s |", test_cases[i], result);
    end

    #10 $finish;
  end

endmodule