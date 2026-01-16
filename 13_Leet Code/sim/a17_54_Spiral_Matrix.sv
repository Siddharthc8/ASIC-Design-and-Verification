`timescale 1ns / 1ps




module a17_54_Spiral_Matrix();

    typedef int ret_type[$];

class solutions;
    
    
    function ret_type spiralOrder(input int matrix[$][$]);
    
    typedef enum { UP, DOWN, RIGHT, LEFT } dir;
    
    int i,j,m,n;   
    int top_wall, right_wall, left_wall, bottom_wall; 
    dir direction;
    ret_type res;
     
    i = 0;
    j = 0;
    m = matrix.size();
    n = matrix[0].size();
    direction = RIGHT;
    
    top_wall = 0;
    right_wall = n;
    bottom_wall = m;
    left_wall = -1;
    
    
    while ( res.size() < m*n ) begin
        if(direction == RIGHT) begin
            while( j < right_wall) begin
                res.push_back(matrix[i][j]);
                j++;
            end
            i++;
            j--;
            direction = DOWN;
            right_wall --;
        end
        else if(direction == DOWN) begin
            while( i < bottom_wall) begin
                res.push_back(matrix[i][j]);
                i++;
            end 
            i--;
            j--;
            direction = LEFT;
            bottom_wall --;
        end
        else if (direction  == LEFT) begin
            while(j > left_wall) begin
                res.push_back(matrix[i][j]);
                j--;
            end
            j++;
            i--;
            direction  = UP;
            left_wall++;
        end
        else begin
            while(i > top_wall) begin
                res.push_back(matrix[i][j]);
                i--;
            end
            i++;
            j++;
            direction = RIGHT;
            top_wall--;
        end
    
    end
    
    
    return res;
        
    endfunction

endclass

    
    
    initial begin
        solutions solver = new();
        
        typedef struct {
            int matrix[$][$];
            int expected[$];
        } test_case_t;
        
        test_case_t test_cases[$] = '{
            // 3x3 matrix
            '{'{{1,2,3},{4,5,6},{7,8,9}}, '{1,2,3,6,9,8,7,4,5}},
            
            // 3x4 matrix
            '{'{{1,2,3,4},{5,6,7,8},{9,10,11,12}}, '{1,2,3,4,8,12,11,10,9,5,6,7}},
            
            // Edge cases
            '{'{{1}}, '{1}},
            '{'{{1,2},{3,4}}, '{1,2,4,3}},
            '{'{{1,2,3,4}}, '{1,2,3,4}},
            '{'{{1},{2},{3}}, '{1,2,3}}
        };
    
        foreach (test_cases[i]) begin
            // Local variable declarations
            int matrix[$][$] = test_cases[i].matrix;
            int expected[$] = test_cases[i].expected;
            ret_type result;
            string pass;
            
            // Function call
            result = solver.spiralOrder(matrix);
            
            // Verification
            pass = (result == expected) ? "PASS" : "FAIL";
            
            // Standardized output format
            $display("Input matrix -> %p \nExpected spiral: %p \nActual   spiral: %p \nResult -> %4s \n\n",
                     matrix,
                     expected,
                     result,
                     pass);
        end
    
        #10 $finish;
    end

endmodule
