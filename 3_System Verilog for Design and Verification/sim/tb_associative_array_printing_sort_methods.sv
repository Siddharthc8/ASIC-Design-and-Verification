`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2025 10:44:25 AM
// Design Name: 
// Module Name: tb_associative_array_printing_sort_methods
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_associative_array_printing_sort_methods();  // abstraction of leetcode 1189


    typedef int ret_type;

class solutions;
    
    // --------------Using associative arrays----------------------------//
    function ret_type set(input string text);
    
        int map[byte];
        int count;
        
        //  Behaves like a set and sorts (map naturally sorts)
        // Setting a dummy value "1". So trying the add another value will just replace the old one
        foreach(text[i]) begin
            if( !map.exists(text[i]) ) map[text[i]] = 1;
            else map[text[i]] ++;
        end
        
        map.delete("a");
        print_i_b_map(map);
//        print_char_map(map);
                    
    endfunction
    
    
    // -------------- Using queues to sort characters ----------------------------//
    function void remove_duplicates(input string str); // Input is a map with string characters as keys
        
        byte res[$];
        
        foreach(str[c]) begin
            byte ch;           // If not declared causes infinite loop
            ch = str[c];
            if( res.size() == 0 || !(ch inside {res}) ) begin
                res.push_back(ch);
            end
        end
        
        
        $display("%s", string'(res));              // Used type conversion to print the entire queue
        //            OR                  //
        foreach(res[i]) $write("%c", res[i]);    // Works
        $display("");
    endfunction  
    
    
    
    // --------------Printing associative aray methods----------------------------//
    
    // helper functions to display map (both work)
    function void print_i_b_map(ref int map[byte]);  // My way
        foreach(map[k]) begin
            string key = string'(k);
            int value = map[k];
            $write("%0s:%0d, ",key, value);
        end
    endfunction
    
    function void print_char_map(ref int map[byte]);  // Slightly complicated but one-liner
        string out = "{ ";
        foreach (map[c]) out = {out, "'", string'(c), "':", $sformatf("%0d", map[c]), ", "};
        out = {out, "}"};
        $display("%s", out);
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
            result = solver.set(text);
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
    
