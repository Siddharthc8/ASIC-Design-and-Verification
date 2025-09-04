`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2024 11:45:48 PM
// Design Name: 
// Module Name: tb_a81
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


module tb_a81();
    
    int count_one = 0;
    int count_two = 0;
    
    event finished;
    
    task example;
    #20;
    $display("example trigger");
    endtask
    
    task one();
    
        while(1) begin
            #20;
            $display("Task 1 trigger at %0t", $time);
            count_one += 1;
        end
        
    endtask
    
    
    task two;
        
        while(1) begin
            #40;
            $display("Task 2 trigger at %0t", $time);
            count_two += 1;
        end
        
    endtask
    
    task display();  // x x x x x x x x x x   // Does not work     
       wait(finished.triggered);
       @(finished);
       $display("Count_one: %0d, Count_two: %0d", count_one, count_two);
    endtask
    
    initial begin
        // Could have just used it without fork and join but just practicing
        fork
            one();
            two();
            display();
        join
        
    end
    
    initial begin
       #200; 
       -> finished;   // x x x x x x x x x x   // Does not work 
       $display("Count_one: %0d, Count_two: %0d", count_one, count_two);
       $finish;
    end
    
endmodule
