`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 10:19:23 PM
// Design Name: 
// Module Name: tb_compare_arrays
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


module tb_compare_arrays();

    int arr1[5] = '{1,2,3,4,5};
    int arr2[5] = '{1,2,3,4,5};
    
    int arr3[5] = '{1,2,3,4,5};
    int arr4[5] = '{5,4,3,2,1};
    
    int status, status2;
    
    initial begin
        
        status = (arr1 == arr2);
        $display("The status of comaparison is %0d", status);
        
        status2 = (arr3 == arr4);
        $display("The status of comaparison is %0d", status2);
        
    end
    
    
endmodule
