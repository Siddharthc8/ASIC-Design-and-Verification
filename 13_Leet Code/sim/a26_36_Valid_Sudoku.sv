`timescale 1ns / 1ps




module a26_36_Valid_Sudoku();


//    // Return type: 1 if the Sudoku board is valid, 0 otherwise
//    typedef bit ret_type;

//    class solutions;

//        // Check rows, columns, and 3×3 sub-boxes for duplicates
//        function ret_type isValidSudoku(input string board[]);
//            // Declarations first
//            int map[byte];
//            int rowStart;
//            int colStart;
//            int row;
//            int col;

//            // Check each row
//            for (int i = 0; i < 9; i++) begin
//                // clear map for this row
//                map.delete();
//                for (int j = 0; j < 9; j++) begin
//                    byte c = board[i][j];
//                    if (c == ".")
//                        continue;
//                    if (map.exists(c))
//                        return 0;
//                    map[c] = 1;
//                end
//            end

//            // Check each column
//            for (int j = 0; j < 9; j++) begin
//                map.delete();
//                for (int i = 0; i < 9; i++) begin
//                    byte c = board[i][j];
//                    if (c == ".")
//                        continue;
//                    if (map.exists(c))
//                        return 0;
//                    map[c] = 1;
//                end
//            end

//            // Check each 3×3 sub-box
//            for (int bi = 0; bi < 9; bi++) begin
//                map.delete();
//                rowStart = (bi/3)*3;
//                colStart = (bi%3)*3;
//                for (int k = 0; k < 9; k++) begin
//                    byte c;
//                    row = rowStart + k/3;
//                    col = colStart + k%3;
//                    c = board[row][col];
//                    if (c == ".")
//                        continue;
//                    if (map.exists(c))
//                        return 0;
//                    map[c] = 1;
//                end
//            end

//            return 1;
//        endfunction
        
//        //--------------------------------------------------------------

//    endclass

//    initial begin
//        automatic solutions solver = new();

//        // Test-case: board array and expected result
//        typedef struct {
//            string board[];
//            bit    expected;
//        } test_case_t;

//        test_case_t test_cases[$] = '{
//            // Valid board
//            '{'{"5.3......","6..195...",".98....6.","8...6...3","4..8.3..1","7...2...6",".6....28.","...419..5","....8..79"}, 1},
//            // Invalid: duplicate '5' in row 0
//            '{'{"553......","6..195...",".98....6.","8...6...3","4..8.3..1","7...2...6",".6....28.","...419..5","....8..79"}, 0},
//            // Invalid: duplicate '6' in column 1
//            '{'{"5.3......","66.195...",".98....6.","8...6...3","4..8.3..1","7...2...6",".6....28.","...419..5","....8..79"}, 0},
//            // Invalid: duplicate '8' in top-left 3×3 box
//            '{'{"8.3......","6..195...",".98....6.","8...6...3","4..8.3..1","7...2...6",".6....28.","...419..5","....8..79"}, 0}
//        };

//        foreach (test_cases[i]) begin
//            // Declarations before assignments
//            string board[] = test_cases[i].board;
//            bit    exp     = test_cases[i].expected;
//            ret_type result;
//            string   pass;

//            // Invocation
//            result = solver.isValidSudoku1(board);
//            pass   = (result == exp) ? "PASS" : "FAIL";

//            // Standardized output
//            $display(
//                "board -> %p\n Expected -> %0d\n Actual   -> %0d\n Result -> %4s\n\n",
//                board,
//                exp,
//                result,
//                pass
//            );
//        end

//        #10 $finish;
//    end

//----------------------------------------------------------------------------------------------

    typedef bit ret_type;

    class solutions;

        // All maps use integer indexing now
        function ret_type isValidSudoku1(input string b[9][9]);
            bit rows[int][int];             // rows[row][digit]
            bit cols[int][int];             // cols[col][digit]
            bit squares[int][int][int];     // squares[row/3][col/3][digit]

            for (int r = 0; r < 9; r++) begin
                for (int c = 0; c < 9; c++) begin
                    int digit;
                    int br;
                    int bc;
                    string val = b[r][c];
                    if (val == ".") continue;

                    digit = val.atoi()-1;  // Convert "5" to 5
                    br = r / 3;
                    bc = c / 3;

                    if (rows[r].exists(digit) || cols[c].exists(digit) || squares[br][bc].exists(digit))
                        return 0;

                    rows[r][digit] = 1;
                    cols[c][digit] = 1;
                    squares[br][bc][digit] = 1;
                end
            end
            return 1;
        endfunction

    endclass

    initial begin
        solutions solver = new();

        typedef struct {
            string board[9][9];
            bit expected;
        } test_case_t;

        string valid_board[9][9] = '{
            '{"5","3",".",".","7",".",".",".","."},
            '{"6",".",".","1","9","5",".",".","."},
            '{".","9","8",".",".",".",".","6","."},
            '{"8",".",".",".","6",".",".",".","3"},
            '{"4",".",".","8",".","3",".",".","1"},
            '{"7",".",".",".","2",".",".",".","6"},
            '{".","6",".",".",".",".","2","8","."},
            '{".",".",".","4","1","9",".",".","5"},
            '{".",".",".",".","8",".",".","7","9"}
        };

        string invalid_board[9][9] = '{
            '{"8","3",".",".","7",".",".",".","."},
            '{"6",".",".","1","9","5",".",".","."},
            '{".","9","8",".",".",".",".","6","."},
            '{"8",".",".",".","6",".",".",".","3"},
            '{"4",".",".","8",".","3",".",".","1"},
            '{"7",".",".",".","2",".",".",".","6"},
            '{".","6",".",".",".",".","2","8","."},
            '{".",".",".","4","1","9",".",".","5"},
            '{".",".",".",".","8",".",".","7","9"}
        };

        test_case_t test_cases[$] = '{
            '{valid_board, 1'b1},
            '{invalid_board, 1'b0}
//            '{{'{default: "."}}, 1'b1}
        };

        foreach (test_cases[i]) begin
            string board[9][9] = test_cases[i].board;
            bit expected = test_cases[i].expected;
            ret_type result = solver.isValidSudoku1(board);
            string pass = (result == expected) ? "PASS" : "FAIL";

            $display("Test Case: %0d\nExpected: %b\nActual:   %b\nResult:   %s", i+1, expected, result, pass);
            $display("Board Snapshot:");
            for (int row = 0; row < 3; row++) begin
                $write("Row %0d: ", row+1);
                for (int col = 0; col < 9; col++) begin
                    $write("%s ", board[row][col]);
                end
                $display("");
            end
            $display("");
        end

        #10 $finish;
    end

endmodule


