`timescale 1ns / 1ps




module a22_383_Ransom_Note();


typedef bit ret_type;

class solutions;

    function ret_type canConstruct1(input string ransomNote, input string magazine);
    
        int map [byte];
        
        foreach(magazine[i]) begin
            
            if( !map.exists(magazine[i]) ) map[magazine[i]] = 1;
            else map[magazine[i]] ++;
            
        end
    
        foreach(ransomNote[i]) begin
            
            if ( !map.exists(ransomNote[i]) ) return 0;
            
            else begin
                if( map[ransomNote[i]] == 1 ) map.delete(ransomNote[i]);   // map.delete for delting an entry
                else map[ransomNote[i]] --;
                //         OR          // 
//                if( map[ransomNote[i]] == 0 ) return 0;
//                else map[ransomNote[i]] --;
            end
            
        end
        
        return 1;
    
    endfunction
    
    
    function ret_type canConstruct(input string ransomNote, input string magazine);
        
        int map1[byte];
        int map2[byte];
        
        // Map1 assignment
        foreach(ransomNote[i]) begin
            if ( !map1.exists(ransomNote[i]) )  map1[ransomNote[i]] = 1;
            else map1[ransomNote[i]] ++;
        end
        
        // Map2 assignment
        foreach(magazine[i]) begin
            if ( !map2.exists(magazine[i]) )  map2[magazine[i]] = 1;
            else map2[magazine[i]] ++;
        end
        
        foreach(ransomNote[i]) begin
            
            if ( !map2.exists(ransomNote[i]) || map1[ransomNote[i]] > map2[magazine[i]] ) return 0;
            
        end
        
        return 1;
     
    endfunction

endclass


    initial begin
        automatic solutions solver = new();

        // Test-case structure: ransomNote, magazine, expected result
        typedef struct {
            string ransomNote;
            string magazine;
            bit    expected;
        } test_case_t;

        // Test vectors
        test_case_t test_cases[$] = '{
            '{"a",    "b",    0},  // cannot construct
            '{"aa",   "ab",   0},  // not enough 'a's
            '{"aa",   "aab",  1},  // can construct
            '{"",     "",     1},  // empty note
            '{"abc",  "abc",  1},  // exact match
            '{"aba",  "ab",   0}   // missing one 'a'
        };

        foreach (test_cases[i]) begin
            // Declarations before assignments
            string   ransomNote = test_cases[i].ransomNote;
            string   magazine   = test_cases[i].magazine;
            bit      exp        = test_cases[i].expected;
            ret_type result;
            string   pass;

            // Invocation
            result = solver.canConstruct(ransomNote, magazine);
            pass   = (result === exp) ? "PASS" : "FAIL";

            // Standardized output
            $display("Ransom Note -> \"%s\" | Magazine -> \"%s\" \nExpected result: %b \nActual   result: %b \nResult -> %4s \n\n",
                     ransomNote,
                     magazine,
                     exp,
                     result,
                     pass);
        end
    
        #10 $finish;
    end

endmodule