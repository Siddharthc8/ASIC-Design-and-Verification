`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2025 07:17:45 PM
// Design Name: 
// Module Name: pattern_matcher
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


module pattern_matcher();
    
    
// METHOD 1 EASY NOT SYNTHESIZABLE SAID BY AI    
module pattern_det (
  input wire clk,
  input wire [31:0] data,
  output reg pat_detected
);
  parameter [63:0] pattern = 64'hDEADBEEFCAFEBABE;

  reg [95:0] buffer;
  logic temp_out;

  always @(posedge clk) begin
    // Slide in 32 bits every cycle
    buffer <= {buffer[63:0], data};
    temp_out <= 0;

    // Instead of 33 comparisons in parallel, we do one per clock
    for (int i = 0; i <= 32; i = i + 1) begin
      if (buffer[i +: 64] == pattern) begin
        temp_out <= 1;
      end
    end
  end
  
  assign pat_detected = temp_out ? 1'b1 : 1'b0;
				// OR
  assign pat_detected = temp_out;
	
endmodule






//-------------------------------------------------------------------------------------------------------------------------------------------------------
// GROK METHOD MORE STABLE AND SYNTHESIZABLE

module pattern_detection (
    input wire clk,
    input wire [31:0] data,
    output reg pat_detected
);
    parameter [63:0] pattern = 64'hDEADBEEFCAFEBABE;

    // Buffer to hold 96 bits (64 for pattern + 32 for max offset)
    reg [95:0] buffer;

    // Combinational logic for pattern matching
    logic temp_out;

    // Shift in new 32-bit data every cycle
    always @(posedge clk) begin
        buffer <= {buffer[63:0], data}; // Slide in 32 bits
    end

    // Check for pattern match at all possible 64-bit alignments (0 to 32)
    always_comb begin
        temp_out = 0;
        for (int i = 0; i <= 32; i++) begin
            if (buffer[i +: 64] == pattern) begin
                temp_out = 1;
            end
        end
    end

    // Output the detection result (synchronous)
    always @(posedge clk) begin
        pat_detected <= temp_out;
    end

endmodule

endmodule
