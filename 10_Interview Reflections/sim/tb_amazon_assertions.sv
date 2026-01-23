`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2025 11:32:38 AM
// Design Name: 
// Module Name: tb_amazon_assertions
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


module tb_amazon_assertions();

    // Screening Round
    
    logic clk, grant, req, rst;
    
    // Within 1:10 cycles grant should get asserted after req is asserted
    assert property( @(posedge clk) disable iff (rst) $rose(req) |-> strong(##[1:10] $rose(grant))) else `uvm_error("ASSERT", "Assertion failed check logs");
    
    // Follow up : How to make sure req stays high until grant goes high
    assert property( @(posedge clk) disable iff (rst) $rose(req) |-> $stable(req) throughout ##[1:10] $rose(grant)) else `uvm_error("ASSERT", "Assertion failed check logs"); 
    // This will not work as -> P throughout Q means P must hold during every cycle when Q holds - but Q must be a sequence that describes a time range or event pattern, not a delay operator.
    
    assert property (@(posedge clk) disable iff (rst) req |-> (req && !grant)[*0:9] ##1 grant) else `uvm_error("ASSERT", "Assertion failed check logs"); 

endmodule
