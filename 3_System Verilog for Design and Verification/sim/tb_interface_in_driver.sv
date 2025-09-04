`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/18/2024 12:43:55 PM
// Design Name: 
// Module Name: tb_interface_in_driver
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


module tb_interface_in_driver();
    
interface and_if;
    logic [3:0] a;
    logic [3:0] b;
    logic [4:0] y;
    logic clk;
endinterface

class Driver;

    virtual and_if aif;    // Calling an interface in a class doesn't require braces n the end
    
    task run();
        forever begin
            @(posedge aif.clk);
            aif.a <= 3;
            aif.b <= 3;
        end
    endtask

endclass 
    
//...........MAIN MODULE.............//

    and_if aif();    // Braces needed at the end if calling in testbench top
    
    and4 dut (
        .a(aif.a),
        .b(aif.b),
        .y(aif.y),
        .clk(aif.clk)
        );
    
    localparam T = 20;  // Clock Period
    initial begin
        aif.clk <= 0;
    end
    
    always #(T/2) aif.clk <= ~aif.clk;
    
    Driver drv;
    
    initial begin
        drv = new();
        drv.aif = aif;
        drv.run();
    end
    
    
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        #100;
        $finish;
    end

endmodule
