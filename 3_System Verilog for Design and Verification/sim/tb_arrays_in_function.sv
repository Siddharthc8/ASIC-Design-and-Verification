`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2024 12:27:41 AM
// Design Name: 
// Module Name: tb_arrays_in_function
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

module tb_arrays_in_function();

// An array is passed to a an argument of a function
    
    bit [3:0] res [16];
    
    function automatic void init_arr (ref bit [3:0] a [16]);
        for(int i = 0; i <= 15; i++) begin
            a[i] = i;
       end
   endfunction

    initial begin
        init_arr(res);
        $display("The elements of the array is: %0p", res);
    end
endmodule
