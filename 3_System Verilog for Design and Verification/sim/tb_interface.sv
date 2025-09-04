`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/17/2024 10:54:18 AM
// Design Name: 
// Module Name: tb_interface
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


module tb_interface();

    interface and_if;
        logic [3:0] a;
        logic [3:0] b;
        logic [4:0] y;
        logic clk;
    endinterface 
    
    //..................MAIN MODULE.................//
    
    and_if aif();
    
    initial begin
        aif.clk = 0;
    end
    
    always #10 aif.clk = ~aif.clk;
    
    and4 dut (.a(aif.a), .b(aif.b), .y(aif.y), .clk(aif.clk));
    
    initial begin
        aif.a <= 1;
        aif.b <= 5;
        repeat(3) @(posedge aif.clk);
        aif.a <= 3;
        #20;
        aif.a <= 4;
        #8;
        aif.a <= 5;
        #20;
        aif.a <= 6;
    $display("a: %0d , b: %d and y: %d",aif.a, aif.b, aif.y );
    end
    
    initial begin
        #100;
        $finish;
    end
  
endmodule
