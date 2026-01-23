`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/24/2025 02:25:36 PM
// Design Name: 
// Module Name: tb_constraints_matrix_apple_interview
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


module tb_constraints_matrix_apple_interview();


/* Write a constraint to follow the rules for the given matrix below. 
 NOTE : the last value of the matrix SHOULD NOT be randomized or touched. */
 
 /* [  X    O   E   O  ]    O -> Odd
    [  O    X   O   E  ]    E -> Even 
    [  E    O   X   O  ]
    [  O    E   O   Z  ]  -> Z indicates do not touch/randomize
*/

class transaction;
    
    rand logic [7:0] matrix [4][4];
    rand logic temp;
//    constraint arr2d { 
//       foreach(matrix[i,j]) {
//         if(i == j && i == $size(matrix, 1) - 1) matrix[i][j] == 'b0;  // Last element ie 3,3
//           else if(i == j) matrix[i][j] == 'b1;                        // The diagonal elements
//           else if((i+j)%2 == 0) matrix[i][j]%2 == 0;                  // Even places even values
//           else matrix[i][j]%2 != 0;                                   // Odd places odd values
//       }
//         foreach(matrix[i,j]) if(i != j) matrix[i][j] inside {[2:20]}; // Restrict all values 0 to 20 except diagonal values
//   }
    
    function void pre_randomize();
        
    endfunction
    
    function void post_randomize();
    
        foreach(matrix[i,j]) begin                   // NOTE : 4 state variables can only be assigend in post-randomize nad not inside constraints
        
            if(i == j && i == $size(matrix)-1 ) begin       // Without this constraint and not randomizing by setting rand_mode 0 will default to "x" because of logic type
                matrix[i][j] = 'z;
            end
            
            else if(i == j && i != $size(matrix) - 1) begin                                                                                                            
                matrix[i][j] = 'z;                                                                                                 
            end
            
        end
        
    endfunction
    
    constraint arr2d_ { 
    foreach(matrix[i,j]) {
        // Last element remains 'Z' (unchanged)
//        if(i == j && i == $size(matrix, 1) - 1) {
//            soft matrix[i][j] == '1;  // Here we set it to zero. To not touch it, we have set matrix[3][3].rand_mode(0) in the initial block before randomizing
//        }                             // But make sure to use soft in case there is an existing constraint                     
        // Diagonal elements (1)                                                                                                
//        if(i == j) {                                                                                                            
//            matrix[i][j] == 'x;      // Cannot assign 4 state variables in constraints                                                                                             
//        }                                                                                                                       
        // Even positions (E) - where (i+j) is even AND not diagonal                                                            
        if((i+j) % 2 == 0) {                                                                                               
            matrix[i][j] % 2 == 0;  // Must be even                                                                             
        }                                                                                                                       
        // Odd positions (O) - where (i+j) is odd AND not diagonal                                                              
        else {                                                                                                                  
            matrix[i][j] % 2 != 0;  // Must be odd                                                                              
        }                                                                                                                       
                                                                                                                                
        // Restrict all values 0 to 20 except diagonal values                                                                   
        if(i != j ) {                                                                                                           
            matrix[i][j] inside {[2:20]};                                                                                       
        }                                                                                                                       
    }                                                                                                                           
}                                                                                                                               
endclass                                                                                                                        
                                                                                                                                
    initial begin                                                                                                               
    automatic transaction tr = new(); 
    tr.matrix[3][3].rand_mode(0);             // Here we have turned off the constraint
    if(!tr.randomize()) $display("error");                                                                                             
    else begin
        for(int i=0; i<4; i++) begin
            for(int j=0; j<4; j++) begin
                $write("%d ", tr.matrix[i][j]);
            end
            $display("");
        end
    end
end
endmodule
