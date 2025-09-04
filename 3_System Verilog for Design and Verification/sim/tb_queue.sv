`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 11:29:17 PM
// Design Name: 
// Module Name: tb_queue
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


module tb_queue();

    int arr[$];   // adding $ sign inside square brackets makes it queue/stack
    int arr_limited[$:10];   // queue of size 10
    int i, j;   
    
    initial begin         //  Methods for  queue / stack
        arr = '{1,2,3};
        $display("Arr: %0p, size: %0d", arr, $size(arr));
        
        arr.push_front(7); // Adds the item to the beginning of the stack
        $display("Arr: %0p, size: %0d", arr, $size(arr));
        
        arr.push_back(9); // Adds the item to the end of the stack
        $display("Arr: %0p, size: %0d", arr, $size(arr));
        
        arr.insert(2, 8);      // Syntax     array.insert(INDEX , VALUE)
        $display("Arr: %0p, size: %0d", arr, $size(arr));
        
        i = arr.pop_front();     // To pop the first element and returns a value
        $display("Arr: %0p, size: %0d, popped_value: %0d", arr, $size(arr), i);
        
        j = arr.pop_back();     // To pop the last element and returns a value
        $display("Arr: %0p, size: %0d, popped_value: %0d", arr, $size(arr), j);
        
        arr.delete(1);      // Syntax     array.insert(INDEX , VALUE)
        $display("Arr: %0p, size: %0d", arr, $size(arr));
                
    end
    


endmodule
