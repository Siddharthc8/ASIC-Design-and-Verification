`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2025 02:00:20 PM
// Design Name: 
// Module Name: tb_fibonacci
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


module tb_fibonacci();

class solutions;
    
    function int fib_normal(input int n);
        
        if(n <= 1) return n;
        
//        $write("%d", n);
        return { fib_normal(n-1) + fib_normal(n-2) };    
    
    endfunction
    
    function int fib_optimized(input int n);
        
        int a, b;
        int temp;
        
        a = 0;
        b = 1;
        
        if( n <= 1) return n;
        
        $write("%d\t", a);
        $write("%d\t", b);
        
        for(int i = 2; i <= n; i++) begin
            temp = a + b;
            a = b;
            b = temp;
            $write("%d\t", b);
        end
        $display("\n");
        return b;
    endfunction

endclass


    initial begin
        solutions solver = new();

        typedef struct {
            int n;
            int expected;
        } test_case_t;

        test_case_t test_cases[$] = '{
            '{0, 0},
            '{1, 1},
            '{2, 1},
            '{3, 2},
            '{4, 3},
            '{5, 5},
            '{6, 8},
            '{7, 13},
            '{8, 21},
            '{9, 34},
            '{10, 55}
        };

        foreach (test_cases[i]) begin
            int n = test_cases[i].n;
            int expected = test_cases[i].expected;
            int result_normal, result_optimized;
            string pass_normal, pass_optimized;

            result_normal = solver.fib_normal(n);
            result_optimized = solver.fib_optimized(n);

            pass_normal = (result_normal == expected) ? "PASS" : "FAIL";
            pass_optimized = (result_optimized == expected) ? "PASS" : "FAIL";

            $display("n = %0d | Expected = %0d | Normal = %0d (%s) | Optimized = %0d (%s)",
                     n, expected, result_normal, pass_normal, result_optimized, pass_optimized);
        end

        #10 $finish;
    end

endmodule
