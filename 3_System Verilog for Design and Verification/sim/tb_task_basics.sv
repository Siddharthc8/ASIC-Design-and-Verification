`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 03:43:03 PM
// Design Name: 
// Module Name: tb_task_basics
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

// Timing control can be passed to tasks but not to functions


module tb_task_basics(); 
    
    // Default direction for arguments is input
    
    bit clk = 0;
    
    always #10 clk = ~clk;   // Timeperiod is 20ns so 50MHz
    
    
    task add (input bit [3:0] a, input bit [3:0] b, output bit [4:0] y);   
        y = a + b;
        $display("a: %0d, b: %0d, y: %0d ", a, b, y);
    endtask
    
    bit [3:0] a,b;
    bit [4:0] y;
    
    task stim_a_b();
        a = 1;
        b = 3;
        add(a,b,y);
        #10;
        a = 5;
        b = 6;
        add(a,b,y);
        #10;
        a =7;
        b = 8; 
        add(a,b,y);
        #10;
    endtask
    
    task stim_clk();
        @(posedge clk)  // wait statement
        a = $urandom();    // Ramndom bits will be truncated to 4 bits as a is 4 bits wide
        b = $urandom();    
        add(a,b,y);
    endtask
    
    
    initial begin
        stim_a_b();
    end
    
    initial begin
        for(int i = 0; i<11; i++) begin
            stim_clk();    
        end
    end
    
    
    initial begin
        #110 $finish;
    end
    
    
endmodule