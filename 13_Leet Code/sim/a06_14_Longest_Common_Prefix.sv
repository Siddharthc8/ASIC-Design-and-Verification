`timescale 1ns / 1ps




module a06_14_Longest_Common_Prefix();

  class solutions;
    // Method: Find longest common prefix
    function string longestCommonPrefix(string strs[$]);
      string prefix;
     
      if (strs.size() == 0) return "";
      
      prefix = strs[0];
      
      foreach (strs[i]) begin
        while (strs[i].substr(0, prefix.len()-1) != prefix) begin
          prefix = prefix.substr(0, prefix.len()-2);
          if (prefix == "") return "";
        end
      end
      return prefix;
    endfunction
 //-------------------------------------------------------- 
  
  function string neet_code(string strs[$]);
    
    string prefix, res;
    string curr_str;
    
    res = "";
    prefix = strs[0];
    
    
    if(strs.size() == 0) begin
    return res;
    end
    
    for (int i=0; i< prefix.len(); i++) begin
        for(int j =0; j< strs.size(); j++) begin        // can also use |->  foreach(strs[j]) begin
            curr_str = strs[j];                  // Temp allocation -> Just to make it more readable and understandable
            if (curr_str[i] != prefix[i] || curr_str.len() == i)
                return res;
        end
        res = {res, prefix[i]};
    end
    return res;
  
  endfunction
  //----------------------------------------------------------
  
  function string greg(string strs[$]);
    
    string prefix, result, curr_str;
    int min_len;
    
    min_len = strs[0].len();
    prefix = strs[0];
    
    foreach(strs[i]) begin
        min_len = min_len < strs[i].len() ? min_len : strs[i].len();
    end
    
    if(min_len == 0) return "";
    
    for(int i = 0; i < min_len; i++) begin
        foreach(strs[j]) begin
            curr_str = strs[j];
            if (curr_str[i] != prefix[i])
                return result;
        end
        result = {result, prefix[i]};
    end
    
    return result;
  endfunction

endclass

//---------------------------------------------------------------------------------------
  initial begin
    solutions solver = new();
    string test_cases[4][$] = '{
      '{"flower","flow","flight"},  // Expected: "fl"
      '{"dog","racecar","car"},     // Expected: ""
      '{"interspecies","interstellar","interstate"},  // Expected: "inters"
      '{"single"}                   // Expected: "single"
    };

    $display("| Strings                     | LCP       |");
    $display("|-----------------------------|-----------|");

    foreach (test_cases[i]) begin
    string result1, result2, result3;
      result1 = solver.longestCommonPrefix(test_cases[i]);
      $display("| %p | %-8s |\n", test_cases[i], result1);
      result2 = solver.neet_code(test_cases[i]);
      $display("| %p | %-8s |\n", test_cases[i], result2);
      result3 = solver.greg(test_cases[i]);
      $display("| %p | %-8s |\n", test_cases[i], result3);
    end

    #10 $finish;
  end

endmodule