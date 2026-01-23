`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2025 09:27:52 AM
// Design Name: 
// Module Name: tb_dums
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


module tb_dums();

    // Signals
    logic clk;
    logic a, b;
    
    // Clock parameters
    parameter CLK_PERIOD = 10; // 10 ns period (100 MHz)
    parameter CLK_HALF = CLK_PERIOD / 2; // 5 ns
    
    // Timing parameters
    parameter SETUP_TIME = 2; // 2 ns setup requirement
    parameter HOLD_TIME = 1;  // 1 ns hold requirement
    
    // Placeholder DUT (example combinational logic)
    logic out;
    assign out = a & b; // Example: DUT computes AND of a and b
    
    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_HALF) clk = ~clk;
    end
    
    // Stimulus generation
    initial begin
        // Initialize signals
        a = 0;
        b = 0;
        
        // Test case 1: Valid setup and hold (changes well before/after clk)
        #15; // Wait for a stable point
        a = 1; // Change at t=15 ns, 5 ns before rising edge at t=20 ns
        b = 1;
        #8;  // Hold stable past t=21 ns (clk rising at t=20 ns)
        a = 0; // Change at t=23 ns, after hold time
        
        // Test case 2: Setup violation for a (changes too close to clk edge)
        #7; // At t=30 ns
        a = 1; // Change at t=30 ns, exactly at rising edge (violates 2 ns setup)
        #5;
        a = 0;
        
        // Test case 3: Hold violation for b (changes too soon after clk edge)
        #5; // At t=35 ns
        b = 1; // Change at t=35 ns, 5 ns before rising edge at t=40 ns
        #6; // At t=41 ns
        b = 0; // Change at t=41 ns, only 1 ns after clk edge (violates 1 ns hold)
        
        // Test case 4: Valid transitions
        #9; // At t=50 ns
        a = 1; // Change at t=50 ns, 5 ns before t=55 ns
        b = 1;
        #8; // Hold stable past hold time
        a = 0;
        b = 0;
        
        // End simulation
        #20;
        $finish;
    end
    
    // Assertions
    // Setup Check 1: Signal a must be stable 2 ns before rising edge of clk
    property setup_check_a;
        @(posedge clk) $stable(a) || $changed(a) |-> $past(a, 1) == a;
    endproperty
    assert property (setup_check_a)
        else $error("Setup violation: Signal a changed within 2 ns before posedge clk at time %t", $time);
    
    // Setup Check 2: Signal b must be stable 2 ns before rising edge of clk
    property setup_check_b;
        @(posedge clk) $stable(b) || $changed(b) |-> $past(b, 1) == b;
    endproperty
    assert property (setup_check_b)
        else $error("Setup violation: Signal b changed within 2 ns before posedge clk at time %t", $time);
    
    // Hold Check 1: Signal a must remain stable 1 ns after rising edge of clk
    property hold_check_a;
        @(negedge clk) disable iff ($time < 1) // Avoid initial condition
        $rose(clk, @(posedge clk)) |-> ##1 $stable(a);
    endproperty
    assert property (hold_check_a)
        else $error("Hold violation: Signal a changed within 1 ns after posedge clk at time %t", $time);
    
    // Hold Check 2: Signal b must remain stable 1 ns after rising edge of clk
    property hold_check_b;
        @(negedge clk) disable iff ($time < 1)
        $rose(clk, @(posedge clk)) |-> ##1 $stable(b);
    endproperty
    assert property (hold_check_b)
        else $error("Hold violation: Signal b changed within 1 ns after posedge clk at time %t", $time);
    
    // Dump signals for waveform viewing
//    initial begin
//        $dumpfile("tb_timing_check.vcd");
//        $dumpvars(0, tb_timing_check);
//    end
    
endmodule
