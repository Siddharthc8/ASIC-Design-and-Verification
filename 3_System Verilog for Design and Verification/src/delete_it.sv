`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2025 09:09:59 PM
// Design Name: 
// Module Name: delete_it
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


module pattern_detection(input [31:0] data, input clk, output pat_detected);
parameter pattern = 64'hABCDABCDABCDABCD;

logic [95:0] buffer;
logic detected;

always_ff @(posedge clk) begin
    
    buffer <= { buffer[95:32], data};
    detected <= 0;
    
    for(int i = 0; i<=32; i++) begin
        
        if(pattern == buffer[i +: 64]) begin
            detected <= 1;
        end
    
    end

end


assign pat_detected = detected;

endmodule 


// -------------------------------------------------------------------------------
module pattern_detection (
    input wire clk,
    input wire [31:0] data,
    output reg pat_detected
);
    parameter [63:0] pattern = 64'hDEADBEEFCAFEBABE;
    
    
    logic [95:0] buffer;
    logic temp_out;
    
    always @(posedge clk) begin
        
    buffer = {buffer[95:32], data};
    
    end
    
    always_comb begin
    
        temp_out = 0;
        
        for(int i = 0; i<= 32; i++) begin   
            temp_out = (pattern == buffer[i+:64]);  
        end
    
    end


endmodule













