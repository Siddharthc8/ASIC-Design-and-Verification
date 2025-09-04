`timescale 1ns / 1ps




module a20_771_Jewels_and_Stones();

typedef int ret_type;

class solutions;

    function ret_type numJewelsInStones(input string jewels, input string stones);
        
        ret_type count;
        byte c;
        bit map [byte];
        
        count = 0;
        
        foreach(jewels[i]) begin   // Behaves like a set
            map[jewels[i]] = 1;
        end
        
        foreach(stones[i]) begin
            if( map.exists(stones[i]) ) count++;
        end
        
        return count;        
    endfunction
    

endclass

    initial begin
        solutions solver = new();

        typedef struct {
            string jewels;
            string stones;
            int expected;
        } test_case_t;

        test_case_t test_cases[$] = '{
            '{"a","aAAbbbb",1},
            '{"z","ZZ",0},
            '{"","",0},
            '{"abc","",0},
            '{"","abc",0},
            '{"Aa","aAAbbbb",3}
        };

        foreach (test_cases[i]) begin
            string jewels;
            string stones;
            int expected;
            int result;
            string pass;
            
            jewels = test_cases[i].jewels;
            stones = test_cases[i].stones;
            expected = test_cases[i].expected;
            
            result = solver.numJewelsInStones(jewels, stones);
            pass = (result == expected) ? "PASS" : "FAIL";

            $display("Jewels: \"%s\" | Stones: \"%s\" \nExpected count: %0d \nActual   count: %0d \nResult -> %4s\n\n",
                     jewels,
                     stones,
                     expected,
                     result,
                     pass
            );
        end

        #10 $finish;
    end


endmodule