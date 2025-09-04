`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2025 05:26:33 PM
// Design Name: 
// Module Name: tb_palindrome
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


module tb_palindrome();

    string word ;
    //assign word = "Malayalam";
    
    function bit is_palindrome(string s);
    
        int l = s.len();
        s = s.tolower();
        
        for(int i=0; i < l/2; i++) begin
        
            if (s[i] != s[l-1-i]) return 0;
            
        end
        
        return 1;
    
    
    endfunction
    

    initial begin
    word = "Malayalam";
        if (is_palindrome(word)) $display("True");
        else $display("False");
    end


endmodule
