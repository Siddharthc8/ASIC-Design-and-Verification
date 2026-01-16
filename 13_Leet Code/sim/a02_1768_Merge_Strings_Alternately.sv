`timescale 1ns / 1ps




module a02_1768_Merge_Strings_Alternately();

class solutions;

    function string mergeAlt_while(input string word1, input string word2);
        string merged = "";
        int i = 0;
        int len1 = word1.len();
        int len2 = word2.len();
        int min = len1 < len2 ? len1 : len2;
        
        while (i < len1 || i < len2) begin
            if (i < len1) merged = {merged, word1[i]};
            if (i < len2) merged = {merged, word2[i]};
            i++;
        end
        
//        if (len1 > min) merged = { merged, word1.substr(min, len1-1)};
//        if (len2 > min) merged = { merged, word2.substr(min, len2-1)};
        
        return merged;
    endfunction
    
    
    function string mergeAlt_for(input string word1, input string word2);
        string merged = "";
        int len1 = word1.len();
        int len2 = word2.len();
        int min = len1 < len2 ? len1 : len2;
        
        for(int i = 0; i < min; i++) begin
            merged = {merged, word1[i], word2[i]};
        end
        
        if (len1 > min) merged = { merged, word1.substr(min, len1-1) }; 
        if (len2 > min) merged = { merged, word2.substr(min, len2-1) }; 
    
        return merged;
    endfunction
        
endclass

    
    initial begin
    solutions solver = new();
    string test_cases[3][2] = '{
      {"abc", "pqr"},     // Expected: "apbqcr"
      {"ab", "pqrs"},     // Expected: "apbqrs"
      {"abcd", "pq"}      // Expected: "apbqcd"
    };

    $display("| Test Case     | Result         |");
    $display("|---------------|----------------|");

    foreach (test_cases[i]) begin
      string result1 = solver.mergeAlt_while(test_cases[i][0], test_cases[i][1]);
      string result2 = solver.mergeAlt_for(test_cases[i][0], test_cases[i][1]);
      $display("| %s + %s | res1 : %s | res2 : %s |", 
               test_cases[i][0], test_cases[i][1], result1, result2);

    end

    #10 $finish;
  end

endmodule