`timescale 1ns / 1ps




module a03_13_Roman_to_Integer();

class solutions;

    int roman_map[string] = {
        "I" : 1,
        "V" : 5,
        "X" : 10,
        "L" : 50,
        "C" : 100,
        "D" : 500,
        "M" : 1000
    };
    
    function int romanToInt(input string s);
    
        int res = 0;
        for(int i = 0; i < s.len()-1; i++) begin
            if ( roman_map[s[i]] < roman_map[s[i+1]] ) res -= roman_map[s[i]];
            else res += roman_map[s[i]];
        end
        
        res += roman_map[s[s.len()-1]];
        
        return res;
    endfunction


endclass



    initial begin
        solutions solver = new();
        string test_cases[6] = '{
          "III",      // Expected: 3
          "LVIII",    // Expected: 58
          "MCMXCIV",  // Expected: 1994
          "IV",       // Expected: 4
          "IX",       // Expected: 9
          "XLII"      // Expected: 42
        };
    
        $display("| Roman Numeral | Integer Value |");
        $display("|---------------|---------------|");
    
        foreach (test_cases[i]) begin
          int result = solver.romanToInt(test_cases[i]);
          $display("| %-13s | %13d |", test_cases[i], result);
        end
    
        #10 $finish;
  end

endmodule
