`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2024 07:36:31 PM
// Design Name: 
// Module Name: mod_m_counter
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


module mod_m_counter
    #(parameter m = 10, n = $clog2(m) )
    (
        input logic clk, reset,   
        output logic [n-1:0] q,
        output logic saturation
    );
    
      // Parameters
      //localparam n = $clog2(m);
                                 
    // Signal decalaration
    logic [n-1:0] c_s, n_s;
    
    always_ff @(posedge clk, posedge reset)
    begin
        if (reset)
            c_s <= 0;
        else 
            c_s <= n_s;
    end
    
    // Next state logic
    assign n_s = (c_s == (m - 1))? 0: c_s + 1;
    
    // Saturation condition
    assign saturation = (c_s == m - 1)? 1'b1 : 1'b0;
    
    // Output logic
    assign q = c_s;
    
endmodule

