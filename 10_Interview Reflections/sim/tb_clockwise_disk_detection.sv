`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2025 07:13:21 PM
// Design Name: 
// Module Name: tb_clockwise_disk_detection
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

//`include "clockwise_disk_pkg.vh"
//import clockwise_disk_pkg::*;
//`include "clockwise_detection_enum__pkg.sv"


module tb_clockwise_disk_detection();

  // Testbench signals
  logic clk;
  logic rst_n;
  logic P1;
  logic P2;
//  logic direction;

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100 MHz clock
  end

  // Instantiate DUT
  clockwise_disk_detection dut (
    .clk(clk),
    .rst_n(rst_n),
    .P1(P1),
    .P2(P2)
//    .direction(direction)
  );

//   Bind assertions to DUT
  bind clockwise_disk_detection clockwise_disk_assertions assert_inst (
    .clk(clk),
    .rst_n(rst_n),
    .current_state(dut.current_state)
  );

  // Test stimulus
  initial begin
    // Initialize signals
    rst_n = 0;
    P1 = 0;
    P2 = 0;

    // Reset
    #10 rst_n = 1;

    // Simulate clockwise rotation: S0 -> S2 -> S3 -> S1
    #10 P1 = 1; P2 = 0; // S2
    #10 P1 = 1; P2 = 1; // S3
    #10 P1 = 0; P2 = 1; // S1
    #10 P1 = 0; P2 = 0; // S0

    // Simulate counterclockwise rotation: S0 -> S1 -> S3 -> S2
    #10 P1 = 0; P2 = 1; // S1
    #10 P1 = 1; P2 = 1; // S3
    #10 P1 = 1; P2 = 0; // S2
    #10 P1 = 0; P2 = 0; // S0

    #20 $finish;
  end
  
  // ----------------------------------------------------------------------
  
//  sequence clockwise_seq;
//    (dut.current_state == dut.S0) ##1 (dut.current_state == dut.S2) ##1 (dut.current_state == dut.S3) ##1 (dut.current_state == dut.S1);
//  endsequence

//  // Counterclockwise sequence: S0 -> S1 -> S3 -> S2
//  sequence counterclockwise_seq;
//    (dut.current_state == dut.S0) ##1 (dut.current_state == dut.S1) ##1 (dut.current_state == dut.S3) ##1 (dut.current_state == dut.S2);
//  endsequence

//  // Assertion for clockwise sequence (informational, should pass)
//  property check_clockwise;
//    @(posedge clk) disable iff (!rst_n)
//    clockwise_seq |-> (1'b1); // No action needed, just confirm it happens
//  endproperty

//  // Assertion for counterclockwise sequence (should fail with error)
//  property check_counterclockwise;
//    @(posedge clk) disable iff (!rst_n) 
//    counterclockwise_seq |-> (1'b1);
//  endproperty

//  // Instantiate assertions
//  assert_clockwise: assert property (check_clockwise) $info("-------------------------------Clockwise rotation detected!");
//    else $info("Clockwise sequence check failed, but this is just for monitoring.");

//  assert_counterclockwise: assert property (check_counterclockwise) $error("!!!!!!!!!!!!!!!!!!!!!!!!!!NO NO Anti-Clockwise Rotation");
//    else $info("Counterclockwise sequence detected, which is not allowed!");

  
  // -----------------------------------------------------------------------

  // Dump signals for waveform
//  initial begin
//    $dumpfile("tb_clockwise_disk.vcd");
//    $dumpvars(0, tb_clockwise_disk);
//  end

endmodule