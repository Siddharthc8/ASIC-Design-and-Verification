`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2025 11:33:03 AM
// Design Name: 
// Module Name: tb_amazon_constraints
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


module tb_amazon_constraints();

class transaction extends uvm_sequence_item;
`uvm_object_utils(transaction)
    
    function new(input string path = "transaction");
        super.new(path);
    endfunction
    
    // Screening Round
    // Write a constraint to make sure every even item in an array is even and every odd item is odd.
    
    int arr[10];
    
    constraint even_odd {
        foreach(arr[i]) {
            if (i%2 == 0) arr[i] % 2 == 0;
            else arr[i] % 2 != 0;
        }
    }
    
endclass
endmodule
