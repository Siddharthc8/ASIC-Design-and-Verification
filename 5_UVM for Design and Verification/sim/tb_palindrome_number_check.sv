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

endmodule