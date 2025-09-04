`timescale 1ns / 1ps




module a24_1189_Maximum_Number_of_Balloons();

    typedef int ret_type;

class solutions;

    function ret_type maxNumberOfBalloons(input string text);
    
        int map[byte];
        int count;
        int min;
        string balloon;
        int b_map[byte];
        
        min = 1 << 30;
        balloon = "balloon";    
        
        map = counter(text);
        b_map = counter(balloon);
        
        
        foreach(b_map[k]) begin
            
            if(!map.exists(k)) return 0;
            else count = map[k] / b_map[k];
            
            min = min < count ? min : count;
            
        end
        
        
        print_i_b_map(map);
        print_i_b_map(b_map);
//        print_char_map(map);
                 
        return min;
    
    endfunction
    //---------------------------------------------------------------------
    // helper functions to display map (both work)
    function void print_i_b_map(ref int map[byte]);  // My way
        foreach(map[k]) begin
            string key = string'(k);
            int value = map[k];
            $write("%0s:%0d, ",key, value);
        end
    endfunction
    //----------------------------------------------------------------------
    function void print_char_map(ref int map[byte]);  // Slightly complicated
        string out = "{ ";
        foreach (map[c]) out = {out, "'", string'(c), "':", $sformatf("%0d", map[c]), ", "};
        out = {out, "}"};
        $display("%s", out);
    endfunction
    //---------------------------------------------------------------------------
     typedef int i_b_map[byte];
    function i_b_map counter(input string str);
        
        i_b_map map;
        
        foreach(str[i]) begin
            if ( !map.exists(str[i]) ) map[str[i]] = 1;
            else map[str[i]] ++;
        end
        
        return map;
    endfunction
    
endclass

    initial begin
        automatic solutions solver = new();

        // Test-case structure: input text and expected count
        typedef struct {
            string text;
            int    expected;
        } test_case_t;

        // Test vectors
        test_case_t test_cases[$] = '{
            '{"nlaebolko",             1},
            '{"loonbalxballpoon",      2},
            '{"leetcode",              0},
            '{"balloonballoonballoon", 3},
            '{"",                     0},
            '{"balon",                0}
        };

        foreach (test_cases[i]) begin
            // Declarations before assignments
            string text = test_cases[i].text;
            int    exp  = test_cases[i].expected;
            ret_type result;
            string   pass;

            // Invocation
            result = solver.maxNumberOfBalloons(text);
            pass   = (result == exp) ? "PASS" : "FAIL";

            // Standardized output
            $display(
                "text -> \"%s\" \nExpected -> %0d \nActual   -> %0d \nResult -> %4s \n\n",
                text,
                exp,
                result,
                pass
            );
        end

        #10 $finish;
    end

endmodule
    
