`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2025 07:59:53 PM
// Design Name: 
// Module Name: sva_clockwise_disk_detection
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

import clockwise_detection_enum_pkg::*;

module clockwise_disk_assertions (
  input logic clk,
  input logic rst_n,
  input logic [1:0] current_state
);
    
//    typedef enum logic [1:0] {
//    S0 = 2'b00,  // (P1, P2) = (0,0)
//    S1 = 2'b01,  // (P1, P2) = (0,1)
//    S2 = 2'b10,  // (P1, P2) = (1,0)
//    S3 = 2'b11   // (P1, P2) = (1,1)
//  } state_t;

  // FSM signals
  state_t current_state, next_state;
  
  
  // Import state_t enum from the DUT
//  import clockwise_disk_detection_pkg::*;
  
  // Clockwise sequence: S0 -> S2 -> S3 -> S1
  sequence clockwise_seq;
    (current_state == S0) ##1 (current_state == S2) ##1 (current_state == S3) ##1 (current_state == S1);
  endsequence

  // Counterclockwise sequence: S0 -> S1 -> S3 -> S2
  sequence counterclockwise_seq;
    (current_state == S0) ##1 (current_state == S1) ##1 (current_state == S3) ##1 (current_state == S2);
  endsequence

  // Assertion for clockwise sequence (informational, should pass)
  property check_clockwise;
    @(posedge clk) disable iff (!rst_n)
//    clockwise_seq |-> (1'b1); // No action needed, just confirm it happens
    (1'b1) |-> clockwise_seq;
  endproperty

  // Assertion for counterclockwise sequence (should fail with error)
  property check_counterclockwise;
    @(posedge clk) disable iff (!rst_n) 
//    counterclockwise_seq |-> (1'b1);
    (1'b1) |-> counterclockwise_seq;
  endproperty

  // Instantiate assertions
  assert_clockwise: assert property (check_clockwise) $info("-------------------------------Clockwise rotation detected!");
    else $info("Clockwise sequence check failed, but this is just for monitoring.");

  assert_counterclockwise: assert property (check_counterclockwise) $error("!!!!!!!!!!!!!!!!!!!!!!!!!!NO NO Anti-Clockwise Rotation");
    else $info("Counterclockwise sequence detected, which is not allowed!");

endmodule


//`ifndef DISK_ROTATION_SVA_SV
//`define DISK_ROTATION_SVA_SV

//module disk_rotation_sva (
//  input logic clk,          // Clock signal
//  input logic rst_n,        // Active-low reset
//  input logic P1,           // Sensor P1
//  input logic P2,           // Sensor P2
//  input state_t current_state,  // FSM current state
//  input logic direction     // Direction: 1=clockwise, 0=counterclockwise
//);

//  // FSM state encoding (must match DUT)
//  typedef enum logic [1:0] {
//    S0 = 2'b00,  // (P1, P2) = (0,0)
//    S1 = 2'b01,  // (P1, P2) = (0,1)
//    S2 = 2'b10,  // (P1, P2) = (1,0)
//    S3 = 2'b11   // (P1, P2) = (1,1)
//  } state_t;

//  // Property to check clockwise rotation: (1,0) -> (1,1)
//  property p_clockwise;
//    @(posedge clk) disable iff (!rst_n)
//      (P1 == 1 && P2 == 0) |-> ##1 (P1 == 1 && P2 == 1);
//  endproperty

//  // Property to check counterclockwise rotation: (1,0) -> (0,0)
//  property p_counterclockwise;
//    @(posedge clk) disable iff (!rst_n)
//      (P1 == 1 && P2 == 0) |-> ##1 (P1 == 0 && P2 == 0);
//  endproperty

//  // Property to check FSM state transitions
//  property p_fsm_sequence;
//    @(posedge clk) disable iff (!rst_n)
//      (current_state == S2 && P1 == 1 && P2 == 0) |-> ##1 (
//        // Clockwise: S2 -> S3 (1,1)
//        (current_state == S3 && P1 == 1 && P2 == 1 && direction == 1) ||
//        // Counterclockwise: S2 -> S0 (0,0)
//        (current_state == S0 && P1 == 0 && P2 == 0 && direction == 0)
//      ) ##1 (
//        // Clockwise: S3 -> S0 (0,0)
//        (direction == 1 && current_state == S0 && P1 == 0 && P2 == 0) ||
//        // Counterclockwise: S0 -> S1 (0,1)
//        (direction == 0 && current_state == S1 && P1 == 0 && P2 == 1)
//      ) ##1 (
//        // Clockwise: S0 -> S1 (0,1)
//        (direction == 1 && current_state == S1 && P1 == 0 && P2 == 1) ||
//        // Counterclockwise: S1 -> S3 (1,1)
//        (direction == 0 && current_state == S3 && P1 == 1 && P2 == 1)
//      ) ##1 (
//        // Clockwise: S1 -> S2 (1,0)
//        (direction == 1 && current_state == S2 && P1 == 1 && P2 == 0) ||
//        // Counterclockwise: S3 -> S2 (1,0)
//        (direction == 0 && current_state == S2 && P1 == 1 && P2 == 0)
//      );
//  endproperty

//  // Assertions
//  assert_clockwise: assert property (p_clockwise)
//    else $error("Clockwise rotation failed: Expected P1=1, P2=1 after P1=1, P2=0");
//  assert_counterclockwise: assert property (p_counterclockwise)
//    else $error("Counterclockwise rotation failed: Expected P1=0, P2=0 after P1=1, P2=0. Counterclockwise rotation detected!");
//  assert_fsm_sequence: assert property (p_fsm_sequence)
//    else $error("FSM sequence failed at state %0s. Counterclockwise rotation detected if direction=0!", current_state.name());

//endmodule

//`endif

//module sva_clockwise_disk_detection(
//  input logic clk,          // Clock signal
//  input logic rst_n,        // Active-low reset
//  input logic P1,           // Sensor P1 (formerly WS)
//  input logic P2            // Sensor P2 (formerly BS)
//    );
    
    
//    // Property to check clockwise rotation: (1,0) -> (1,1)
//  property p_clockwise;
//    @(posedge clk) disable iff (!rst_n)
//      (P1 == 1 && P2 == 0) |-> ##1 (P1 == 1 && P2 == 1);
//  endproperty

//  // Property to check counterclockwise rotation: (1,0) -> (0,0)
//  property p_counterclockwise;
//    @(posedge clk) disable iff (!rst_n)
//      (P1 == 1 && P2 == 0) |-> ##1 (P1 == 0 && P2 == 0);
//  endproperty

//  // Assertions
//  assert_clockwise: assert property (p_clockwise)
//    else $error("Clockwise rotation failed: Expected P1=1, P2=1 after P1=1, P2=0");
//  assert_counterclockwise: assert property (p_counterclockwise)
//    else $error("Counterclockwise rotation failed: Expected P1=0, P2=0 after P1=1, P2=0. Counterclockwise rotation detected!");


////-----------------------------------------------------------------------------------
//  // Property to check FSM state transitions
//  property p_fsm_sequence;
//    @(posedge clk) disable iff (!rst_n)
//      (current_state == S2 && P1 == 1 && P2 == 0) |-> ##1 (
//        // Clockwise: S2 -> S3 (1,1)
//        (current_state == S3 && P1 == 1 && P2 == 1 && direction == 1) ||
//        // Counterclockwise: S2 -> S0 (0,0)
//        (current_state == S0 && P1 == 0 && P2 == 0 && direction == 0)
//      ) ##1 (
//        // Clockwise: S3 -> S0 (0,0)
//        (direction == 1 && current_state == S0 && P1 == 0 && P2 == 0) ||
//        // Counterclockwise: S0 -> S1 (0,1)
//        (direction == 0 && current_state == S1 && P1 == 0 && P2 == 1)
//      ) ##1 (
//        // Clockwise: S0 -> S1 (0,1)
//        (direction == 1 && current_state == S1 && P1 == 0 && P2 == 1) ||
//        // Counterclockwise: S1 -> S3 (1,1)
//        (direction == 0 && current_state == S3 && P1 == 1 && P2 == 1)
//      ) ##1 (
//        // Clockwise: S1 -> S2 (1,0)
//        (direction == 1 && current_state == S2 && P1 == 1 && P2 == 0) ||
//        // Counterclockwise: S3 -> S2 (1,0)
//        (direction == 0 && current_state == S2 && P1 == 1 && P2 == 0)
//      );
//  endproperty

//  // Assertion
//  assert_fsm_sequence: assert property (p_fsm_sequence)
//    else $error("FSM sequence failed at state %0s. Counterclockwise rotation detected if direction=0!", current_state.name());
//endmodule
