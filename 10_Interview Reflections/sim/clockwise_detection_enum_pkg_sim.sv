`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 11:27:37 AM
// Design Name: 
// Module Name: clockwise_detection_enum_pkg_sim
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


package clockwise_detection_enum_pkg_sim;
  typedef enum logic [1:0] {
    S0 = 2'b00,  // (P1, P2) = (0,0)
    S1 = 2'b01,  // (P1, P2) = (0,1)
    S2 = 2'b10,  // (P1, P2) = (1,0)
    S3 = 2'b11   // (P1, P2) = (1,1)
  } state_t;
endpackage