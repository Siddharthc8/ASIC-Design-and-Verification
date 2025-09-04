`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2025 05:32:07 AM
// Design Name: 
// Module Name: tb_test
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


//module tb_test();


//enum {A1 = 0, A2, A3} enum1;
//enum bit [2:0] {A4 = 1, A5, A6, A7} enum2;
//enum logic[3: 0] {A8 = 5, A9} enum3;
//initial begin
//$display ("enum1 value %b, enum1 name %s " , enum1, enum1.name() ) ;
//$display ("enum2 value %b, enum2 name %s " , enum2, enum2.name() ) ;
//$display ("enum3 value %b, enum3 name %s " , enum3, enum3.name() ) ;
//end
//endmodule


module tb_test;
  	typedef int ret_type;
  function ret_type set(input string text);
    
        int map[byte];
        int count;
        
        //  Behaves like a set
        // Setting a dummy value "1". So trying the add another value will just replace the old one
        foreach(text[i]) begin
            if( !map.exists(text[i]) ) map[text[i]] = 1;
            else map[text[i]] ++;
        end

        print_i_b_map(map);
//        print_char_map(map);
                    
    endfunction
  	
  	function automatic void print_i_b_map(ref int map[byte]);  // My way
        foreach(map[k]) begin
            string key = string'(k);
            int value = map[k];
            $write("%0s:%0d, ",key, value);
        end
        $display("");
    endfunction
    
    //--------------------------------------------
    function void remove_duplicates(input string str); // Input is a map with string characters as keys
        
        byte res[$];
        
        foreach(str[c]) begin
            byte ch;           // If not declared causes infinite loop
            ch = str[c];
            if( res.size() == 0 || !(ch inside {res}) ) begin
                res.push_back(ch);
            end
        end
        
        res.sort();
        
        $display("%s", string'(res));     // Works
        //            OR                  //
//        foreach(res[i]) $write("%c", res[i]);
//        $display("");
    endfunction 
  
  
  initial begin
  	
  	typedef struct {
            string text;
        } test_case_t;

        // Test vectors
        test_case_t test_cases[$] = '{
            '{"nlaebolko"},
            '{"loonbalxballpoon"},
            '{"leetcode"},
            '{"balloonballoonballoon"},
            '{"balon"}
        };
  
  
      foreach(test_cases[i]) begin
        string text;
        text = test_cases[i].text;
        remove_duplicates(text);
      end
  
  end
endmodule 
