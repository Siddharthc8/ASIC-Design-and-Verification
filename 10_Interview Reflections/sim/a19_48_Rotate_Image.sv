`timescale 1ns / 1ps




module a19_48_Rotate_Image();

typedef int ret_type[$][$];

class solutions;
    
    function automatic ret_type rotate(input ret_type matrix);
        
        int n;
        ret_type matrix_res;
        
        if(matrix.size() == 0 || matrix[0].size() == 0) return matrix;
                    
        n = matrix.size();
                
//        foreach (matrix[i]) begin
//            int row_q[$] = {};
//            foreach (matrix[i][j]) begin
//                row_q.push_back(matrix[i][j]);
//            end
//            matrix_res.push_back(row_q);
//        end
            
        // Reverse the rows and then transpose the resultant
//        matrix_res = matrix;                 // Do not do this as it passes the handle and does not copy the contents
        matrix_res = copy_matrix(matrix);
        matrix_res.reverse();
        
        for(int i = 0; i< n; i++) begin
            for(int j = i+1; j < n; j++) begin    // i+1 to transpose the matrix
                int temp;
                temp = matrix_res[i][j];
                matrix_res[i][j] = matrix_res[j][i];
                matrix_res[j][i] = temp;
            end
        end
        
        return matrix_res;
        
    endfunction
    
    // Helper function to copy
    function ret_type copy_matrix(input ret_type matrix);
        return matrix;
    endfunction
    
    
endclass
    

    initial begin
        automatic solutions solver = new();
        
        typedef struct {
            ret_type matrix;
            ret_type expected;
        } test_case_t;
        
        test_case_t test_cases[$] = '{
            // 3x3 matrix
            '{'{{1,2,3},{4,5,6},{7,8,9}}, '{{7,4,1},{8,5,2},{9,6,3}}},
            
            // 4x4 matrix
            '{'{{5,1,9,11},{2,4,8,10},{13,3,6,7},{15,14,12,16}}, 
              '{{15,13,2,5},{14,3,4,1},{12,6,8,9},{16,7,10,11}}},
            
            // Edge cases
            '{'{{1}}, '{{1}}},  // Single element
            '{'{{1,2},{3,4}}, '{{3,1},{4,2}}}  // 2x2 matrix
//            '{ '{{}}, '{{}} }  // Empty matrix
        };
    
        foreach (test_cases[i]) begin
            // Local variable declarations
            ret_type matrix;
            ret_type expected;
            ret_type result;
            string pass;
            
            // Assignmnets
            matrix = test_cases[i].matrix;
            expected = test_cases[i].expected;
            result = solver.rotate(matrix);
            pass = (result == expected) ? "PASS" : "FAIL";
            
            // Standardized output format
            $display("Input matrix -> %p \nExpected rotated: %p \nActual   rotated: %p \nResult -> %4s \n\n",
                     matrix,
                     expected,
                     result,
                     pass);
        end
    
        #10 $finish;
    end

endmodule