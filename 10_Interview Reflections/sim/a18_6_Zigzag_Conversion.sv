`timescale 1ns / 1ps




module a18_6_Zigzag_Conversion();
		
	typedef string ret_type;
	
	class solutions;
	
		function ret_type convert(input string s, input int numRows);
						
			string res[];
			int j;
			int d;
          	ret_type ans;
            
			if (numRows <= 1) return s;
            
          	res = new[numRows];
			j = 0;
			                                     // .len() is for checking string length
          for(int i = 0; i < s.len(); i++) begin // OR foreach(s[i]) begin
				
            res[j] = {res[j], s[i]};
			
				if ( j == 0) 
					d = 1;
				
				else if ( j == numRows - 1) 
					d = -1;
				
				j += d;
			end
          
          for(int i = 0; i< res.size(); i++) begin
            
            ans = {ans, res[i]};
            	
          end
          
          return ans;
		
		endfunction
	
	
	endclass
	
	initial begin
        solutions solver = new();
        
        typedef struct {
            string s;
            int numRows;
            string expected;
        } test_case_t;
        
        test_case_t test_cases[$] = '{
            // Basic cases
            '{"PAYPALISHIRING", 3, "PAHNAPLSIIGYIR"},
            '{"PAYPALISHIRING", 4, "PINALSIGYAHRPI"},
            
            // Edge cases
            '{"A", 1, "A"},
            '{"AB", 1, "AB"},
            '{"ABC", 2, "ACB"},
            '{"ABCDEF", 3, "AEBDFC"},
            '{"", 3, ""}  // Empty string
        };
    
        foreach (test_cases[i]) begin
            // Local variable declarations
            string s = test_cases[i].s;
            int numRows = test_cases[i].numRows;
            string expected = test_cases[i].expected;
            ret_type result;
            string pass;
            
            // Function call
            result = solver.convert(s, numRows);
            
            // Verification
            pass = (result == expected) ? "PASS" : "FAIL";
            
            // Standardized output format
            $display("Input string -> \"%s\" | Rows: %0d \nExpected zigzag: \"%s\" \nActual   zigzag: \"%s\" \nResult -> %4s \n\n",
                     s,
                     numRows,
                     expected,
                     result,
                     pass);
        end
    
        #10 $finish;
    end

endmodule