`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2024 10:29:37 PM
// Design Name: 
// Module Name: tb_multiple_processes_multiple_initial_blocks
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


module tb_multiple_processes_multiple_initial_blocks();

    int data1, data2;
    event done;
    
    /////    Generator
    initial begin
        for(int i = 0; i < 10; i++) begin
        
            data1 = $urandom();
            $display("Data Sent: %0d", data1);
            #10;
        end
        
        -> done;
        
    end
    
    //////    Driver         
    initial begin        // Causes race conditions
        forever begin          // used like always inside an always block
            #10;
            data2 = data1;
            $display("Data Received: %0d", data2);
        end
    end
    
    /////   To mark the end
    initial begin
        wait(done.triggered);
        $finish();
    end
        
endmodule
















