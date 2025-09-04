`timescale 1ns / 1ps

module tb_top();

    // Glocal Signals clk, rst
    
    reg clk;
    reg rst;
    
    reg [3:0] temp;
    
    initial begin
        clk = 1'b0;
        rst = 1'b0;
    end
    
    initial begin
        rst = 1'b1;
        #30;
        rst = 1'b0;
    end
    
    initial begin
        temp = 4'b0100;
        #10;
        temp = 4'b1100;
        #10;
        temp = 4'b0011;
        #10;
    end
    
    initial begin
        $monitor("Temp: %0d at time: %0t", temp, $time);
    end
    
    initial begin
        #200;
        $finish();
    end
    
endmodule