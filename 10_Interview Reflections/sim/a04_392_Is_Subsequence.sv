`timescale 1ns / 1ps




module a04_392_Is_Subsequence();

  class solutions;
  
  
    // Method: Check if s is subsequence of t
    function bit isSubsequence(string s, string t);
      int i = 0, j = 0;
      string res[$]; 
      
      
      while (i < t.len() && j < s.len()) begin
        if (s[j] == t[i]) begin
          res.push_back(string'(s[j]));     // Type converted to "string" as single character in sv is considered a "byte"
          j++;
        end
        i++;
      end
      
      $display("The queue is: %p", res);
      return (j == s.len());
    endfunction

  endclass
  
  

  initial begin
    solutions solver = new();
    string test_cases[5][2] = '{
      {"abc", "ahbgdc"},   // Expected: 1 (true)
      {"axc", "ahbgdc"},   // Expected: 0 (false)
      {"", "ahbgdc"},      // Expected: 1 (true)
      {"b", "abc"},        // Expected: 1 (true)
      {"aaaa", "bbaaaa"}   // Expected: 1 (true)
    };

    $display("| Test Case   | Result |");
    $display("|-------------|--------|");

    foreach (test_cases[i]) begin
      bit result = solver.isSubsequence(test_cases[i][0], test_cases[i][1]);
      $display("| %s in %s | %d      |", 
               test_cases[i][0], test_cases[i][1], result);
    end

    #10 $finish;
  end

endmodule