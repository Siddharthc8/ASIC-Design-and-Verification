`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2025 03:02:10 PM
// Design Name: 
// Module Name: tb_constraint_solve_before
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


module tb_constraint_solve_before();

    class random;
    
    logic mode;
    logic [7:0] vect;
    
     constraint c2 {mode -> vect == 0; solve mode before vect; }  // Since all the variables are randomized at the same time probability of mode 1 may be very less
                                                                  // So, we can randomize mode first before vect, that way mode probability is 1/2
    
    endclass
endmodule
