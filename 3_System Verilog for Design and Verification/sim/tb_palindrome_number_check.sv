module tb_palindrome_number_check();

    function bit is_palindrome_math(int num);
        int original, reversed, digit;

        if (num < 0) return 0;

        original = num; reversed = 0;
        
        while (num > 0) begin
            digit = num % 10;
            reversed = reversed * 10 + digit;
            num = num / 10;
        end

    return (original == reversed);

    endfunction 

    //----------------------------------------------------//

    function is_pal_string(int num);

        string num_str;

        num_str = $sformatf("%0d", num);
        string len = num_str.len();

        for(int i = 0; i < len/2; i++) begin
            if(num_str[i] != num_str[l-1-i]) return False;
        end

        return True;

    endfunction

endmodule