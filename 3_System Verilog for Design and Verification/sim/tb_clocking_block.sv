`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2025 01:22:04 PM
// Design Name: 
// Module Name: tb_clocking_block
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


module tb_clocking_block();

  reg clk = 0;
  reg dout;      
  reg data;     
  reg enab;
  reg din;

  // Clock generation
  always #5 clk = ~clk;

  // Clocking block
  clocking cb @(posedge clk);   
    default input #1ns output #3ns; // Default timing   // Sample 1ns before clocking block event. 
                                                        // Send 3ns after the clocking block event for output
    input dout;  // Output from DUT, input to testbench
    output negedge din;
    output data;   // Input to DUT, output from testbench
    output #5ns enab; // Explicit skew overrides default delay
  endclocking
  
  clocking cb2@(posedge clk);   
//    Assume the follwoing timescale and precision in the main  module
//    timescale 1ns;
//    timeprecision 100ps;
    
    default input #1step output #3ns; // "1step" means it samples 1 precision unit before clocking event ie 100ps
    
    input dout;  
    output data;   
    output negedge enab;      // Can use edge as well where it is driven at negedge after the clocking event
    
    // Assume posedge @5ns and 15ns
    // dout sampled at 14.9ns
    // data driven at 8ns
    // enab driven at 10 ie at negedge
  endclocking
  
  initial begin
    
    @(cb);
    cb.data <= 1'b1;   // using dot operator to reference properties of clockiing block
    cb.enab <= 1'b1;   // Must be non-blocking assignment
    
    @(posedge clk);
    cb.data <= 1'b1;
    cb.enab <= 1'b1;
    
    @(cb.dout);   // Checks one cycle later and detects only when there's a change
    
//    NOTE : Consider a scenario at a point posedge clk. The @(cb) weill see the psoedge whereas @(posedge) will only execute int he next posedge clk.
  end
    
// .....................................

   initial begin
   
   // Skew of "data" = 3ns
   // Skew of "din" = negedge
   
   @(cb);
   cb.data <= 1'b1;   // Applies at 3ns after posedge clk
   cb.din <= 1'b1;    // Applies at negedge after posedge clk
   
   @(cb);
   #1;            // Note it misses posedge ie past the posedge
   cb.data <= 1'b1;  // Waits for next posedge but din is executed as negedge hasn't yet occured    
   cb.din <= 1'b1;   // Applies at negedge after posedge clk
   
   @(cb);
   @(negedge clk);  
   #1;               // Note it misses negedge clk
   cb.data <= 1'b1;  // Normal operation
   cb.din <= 1'b1;   // Normal operation
   
   end


    default clocking cb;

    initial 
    begin
        
        repeat(2) @(cb);  // Wait for 2 default clcoking block cycles
      
      // Double "##" is used for edges of cycle and not time  
        ##2;       // Wait for 2 default clcoking block cycles
        
        ##1 cb.data <= 1'b1;     // Both are same 
        
        ##1; cb.data <= 1'b1;    // Both are same as the delay still relates to one clock cycle delay
        
        // This does not count to the delay count like any delay after this will still be executed fromt he previous instance. Refer Cadence 1.12 quiz 
        cb2.data <= ##3 1'b1;   // This refers to cb2 clcok delay as it tends to a variable in clcoking block "c2"
        
        
        
    end
 
 
 // ......................
 
    clocking cb3 @(posedge clk);
    default output #3;
        
        output data = top.dut.data;   // Have to declare a variable inside clocking block as the top module
        
        // output top.dut.data;       // This is wrong as you have to declare a variable inside clocking block as the top module
        
    endclocking
    
    
endmodule
