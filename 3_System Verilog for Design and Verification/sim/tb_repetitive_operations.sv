`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 07:58:12 PM
// Design Name: 
// Module Name: tb_repetitive_operations
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


module tb_repetitive_operations();
    
    int arr[10] = '{ default : 0};   // Remember these are signed data types
    int arr2[10];
    int arr3[10];
//    int i = 0;
    
    //  FOR loop  //
    initial begin                                // FOR loop 
        for(int i=5; i<$size(arr); i++) begin   // i could have been decalred anywhere before even next to the array decalaration
            arr[i] = i*i;  
        end
    end
    
    initial begin
        #10;
        $display("The array elements of arr are: %0p", arr);
    end
    
    
    
    // FOREACH loop  // 
    initial begin                             // FOREACH loop  // 
        foreach (arr2[i]) begin     // The variable "i" here is independent of any assignments in the program
            arr2[i] = i;            // The loop runs from 0-->9 as the number of elements in that array is 10
        end
    end
    
    initial begin
        #10;
        $display("The array elements of arr2 are: %0p", arr2);
    end
    
    // REPEAT Loop
    initial begin
        int i = 0;
        repeat(10) begin
            arr3[i] = i;             // This "i" is dependent of the "i" declared in the program
            i++;
        end
    end
    
    initial begin
        #10;
        $display("The array elements of arr3 are: %0p", arr3);
    end
endmodule
