`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 08:07:44 PM
// Design Name: 
// Module Name: tb_a53
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


module tb_a53();

// Create a task that will generate stimulus for addr , wr, and en signal as mentioned in a waveform of the Instruction tab. 
// Assume address is 6-bit wide while en and wr both are 1-bit wide. 
// The stimulus should be sent on a positive edge of 25 MHz clock signal

    bit clk = 0;
    bit en, wr;
    bit [5:0] addr;
    
    always #20 clk = ~clk;   // Period 40ns --> 25MHz
    
    task gen();
        #5;
        @(posedge clk);
        en = 1'b1;
        wr = 1'b1;
        repeat(2) @(posedge clk); 
        wr = 1'b0;
        repeat(2) @(posedge clk); 
        en = 1'b0;
        
    endtask
    
    task random();
        addr = $urandom();
    endtask
    
    initial begin
        gen();
        #200 $finish;
    end
    
    always @(posedge clk) begin
        random();
    end

endmodule
