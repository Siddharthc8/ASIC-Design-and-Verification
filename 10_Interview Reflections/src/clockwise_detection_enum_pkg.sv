`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2025 09:18:04 AM
// Design Name: 
// Module Name: clockwise_detection_enum_pkg
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

module clockwise_detection_enum_pkg();
package clockwise_detection_enum_pkg;
  typedef enum logic [1:0] {
    S0 = 2'b00,  // (P1, P2) = (0,0)
    S1 = 2'b01,  // (P1, P2) = (0,1)
    S2 = 2'b10,  // (P1, P2) = (1,0)
    S3 = 2'b11   // (P1, P2) = (1,1)
  } state_t;
endpackage
endmodule