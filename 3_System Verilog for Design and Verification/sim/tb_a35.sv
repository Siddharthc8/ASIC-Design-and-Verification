`timescale 1ns/1ps


module tb_a35();

// Create a Fixed-size array capable of storing 20 elements. 
// Add random values to all the 20 elements by using $urandom function. 
// Now add all the elements of the fixed-size array to the Queue in such a way that 
// the first element of the Fixed-size array should be the last element of the Queue. 
// Print all the elements of both fixed-size array and Queue on Console.
    
    int farr[20];
    int arr[$]; 
    int arr1[$];
    int i, j;   

    initial begin
        foreach(farr[i]) begin
            farr[i] = $urandom();;
        end
        
        for(i=0;i<$size(farr);i++) begin
                arr.push_front(farr[i]);
        end
        
        for(i=0;i<$size(farr);i++) begin
            if(i==0)
                arr1.push_front(farr[i]);
            else
                arr1.insert(i-1,farr[i]);
        end
        
        $display("The array elements of farr: %0p", farr);
        $display("The array elements of arr: %0p", arr);   // Basically in reverse order
        $display("The array elements of arr1: %0p", arr1);  // Only the first element of farr pushed to the end of arr1
        
        #20 $finish;
    end
endmodule