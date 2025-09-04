`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/18/2024 11:35:18 PM
// Design Name: 
// Module Name: tb_modport
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

// To limit the access of the direction of the variables in INTERFACE for a particular class 
module tb_modport();
    
interface and_if;
    logic [3:0] a;
    logic [3:0] b;
    logic [4:0] y;
    logic clk;
    
    // This shows that "a" and "b" will be driven out from the driver class
    modport DRV (output a,b, input y,clk); // Just like a function where and b are exiting from Driver class

endinterface

class Driver;
    
    //  The interface MODPORT restriction is applies as .DRV in the next line
    virtual and_if .DRV aif;    // Calling an interface in a class doesn't require braces n the end
    
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
        // Display command won't work here as run task in driver is a forever loo[p so only exits with $finish command
    end
    
    
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        #100;
        $finish;
    end

endmodule
