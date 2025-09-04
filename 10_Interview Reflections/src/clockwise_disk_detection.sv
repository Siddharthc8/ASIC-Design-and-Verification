`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2025 07:12:57 PM
// Design Name: 
// Module Name: clockwise_disk_detection
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

module clockwise_disk_detection(
  input logic clk,          // Clock signal
  input logic rst_n,        // Active-low reset
  input logic P1,           // Sensor P1 (formerly WS)
  input logic P2            // Sensor P2 (formerly BS)
);


  // FSM state encoding
//  typedef enum logic [1:0] {
//    S0 = 2'b00,  // (P1, P2) = (0,0)
//    S1 = 2'b01,  // (P1, P2) = (0,1)
//    S2 = 2'b10,  // (P1, P2) = (1,0)
//    S3 = 2'b11   // (P1, P2) = (1,1)
//  } state_t;


  // FSM signals
  state_t current_state, next_state;
  logic direction;  // 1 = clockwise, 0 = counterclockwise

  // FSM: State register
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      current_state <= S0;  // Initial state: (1,0)
    else
      current_state <= next_state;
  end

  // FSM: Next state and direction logic
  always_comb begin
    next_state = current_state;
    direction = 1'b0;  // Default: assume counterclockwise

    case (current_state)
      S0: begin  
          if      (P1 == 0 && P2 == 1) next_state = S1;  
          else if (P1 == 1 && P2 == 0) next_state = S2;
          else if (P1 == 1 && P2 == 1) next_state = S3;
          else next_state = S0;
      end
      
      S1: begin  
          if      (P1 == 1 && P2 == 0) next_state = S2;  
          else if (P1 == 1 && P2 == 1) next_state = S3;
          else if (P1 == 0 && P2 == 0) next_state = S0;
          else next_state = S1;
      end
      
      S2: begin  
          if      (P1 == 1 && P2 == 1) next_state = S3;  
          else if (P1 == 0 && P2 == 0) next_state = S0;
          else if (P1 == 0 && P2 == 1) next_state = S1;
          else next_state = S2;
      end
      
      S3: begin  
          if      (P1 == 0 && P2 == 0) next_state = S0;  
          else if (P1 == 0 && P2 == 1) next_state = S1;
          else if (P1 == 1 && P2 == 0) next_state = S2;
          else next_state = S3;
      end
      
      default: next_state = S0;
    endcase
  end


//// ------------------------------------------------------------------------------

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
//        (current_state == S3 && P1 == 1 && P2 == 1) ||
//        // Counterclockwise: S2 -> S0 (0,0)
//        (current_state == S0 && P1 == 0 && P2 == 0)
//      ) ##1 (
//        // Clockwise: S3 -> S0 (0,0)
//        (current_state == S0 && P1 == 0 && P2 == 0) ||
//        // Counterclockwise: S0 -> S1 (0,1)
//        (current_state == S1 && P1 == 0 && P2 == 1)
//      ) ##1 (
//        // Clockwise: S0 -> S1 (0,1)
//        (current_state == S1 && P1 == 0 && P2 == 1) ||
//        // Counterclockwise: S1 -> S3 (1,1)
//        (current_state == S3 && P1 == 1 && P2 == 1)
//      ) ##1 (
//        // Clockwise: S1 -> S2 (1,0)
//        (direction == 1 && current_state == S2 && P1 == 1 && P2 == 0) ||
//        // Counterclockwise: S3 -> S2 (1,0)
//        (current_state == S2 && P1 == 1 && P2 == 0)
//      );
//  endproperty

//  // Assertion
//  assert_fsm_sequence: assert property (p_fsm_sequence)
//    else $error("FSM sequence failed at state %0s. Counterclockwise rotation detected if direction=0!", current_state.name());

endmodule
