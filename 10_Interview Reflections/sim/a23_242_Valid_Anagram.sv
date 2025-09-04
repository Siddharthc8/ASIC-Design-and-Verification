`timescale 1ns / 1ps




module a23_242_Valid_Anagram();


typedef bit ret_type;

class solutions;

    // Helper function to create a dictionary
    typedef int i_b_map[byte];
    function i_b_map counter(input string str);
        
        i_b_map map;
        
        foreach(str[i]) begin
            if ( !map.exists(str[i]) ) map[str[i]] = 1;
            else map[str[i]] ++;
        end
        
    endfunction
    //------------------------------------------------------------------

    function ret_type isAnagram1(input string s, input string t); // O(n+m)
        
        int s_map[byte];
        int t_map[byte];
        
        if(s.len() != t.len()) return 0;
        
        foreach(s[i]) begin
            if ( !s_map.exists(s[i]) )  s_map[s[i]] = 1;
            else s_map[s[i]] ++;
        end
        
        foreach(t[i]) begin
            if ( !t_map.exists(t[i]) )  t_map[t[i]] = 1;
            else t_map[t[i]] ++;
        end
        
        return s_map == t_map;
        
    endfunction
    
    /// ---------------------------------------------
    
    function ret_type isAnagram(input string s, input string t);  // O(n+m)
        
        i_b_map s_map;
        i_b_map t_map;
        
        if(s.len() != t.len()) return 0;
        
        s_map = counter(s);
        t_map = counter(t);
        
        return s_map == t_map;
        
    endfunction
    
    /// ---------------------------------------------
    
    function ret_type isAnagram2(input string s, input string t); // O(n+m)
        
        int map[byte];
        
        foreach(s[i]) begin
            if( !map.exists(s[i]) ) map[s[i]] = 1;
            else map[s[i]] ++;
        end
        
        foreach(t[i]) begin
            if( !map.exists(t[i]) ) return 0;
            else if( map[t[i]] == 1 ) map.delete(t[i]);
            else map[t[i]] --;
        end
        
        return 1;
    endfunction
endclass

    initial begin
        automatic solutions solver = new();

        // Test-case structure: s, t, expected result
        typedef struct {
            string s;
            string t;
            bit    expected;
        } test_case_t;

        // Test vectors
        test_case_t test_cases[$] = '{
            '{"anagram", "nagaram", 1},
            '{"rat",     "car",     0},
            '{"",        "",        1},
            '{"a",       "b",       0},
            '{"ab",      "ba",      1},
            '{"aabbcc",  "abcabc",  1}
        };

        foreach (test_cases[i]) begin
            // Declarations before assignments
            string   s        = test_cases[i].s;
            string   t        = test_cases[i].t;
            bit      exp      = test_cases[i].expected;
            ret_type result;
            string   pass;

            // Invocation
            result = solver.isAnagram(s, t);
            pass   = (result === exp) ? "PASS" : "FAIL";

            // Standardized output
            $display(
                "s -> \"%s\" | t -> \"%s\" \nExpected -> %0d \nActual   -> %0d \nResult -> %4s \n\n",
                s,
                t,
                exp,
                result,
                pass
            );
        end

        #10 $finish;
    end

endmodule
