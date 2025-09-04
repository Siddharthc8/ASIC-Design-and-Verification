`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2025 09:05:26 PM
// Design Name: 
// Module Name: int_prac
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


module int_prac (
    input  logic clk, rst,
    input  logic [3:0] a, b,
    input  logic func,
    
    output logic [7:0] res,
    output logic done
);
    
    logic [7:0] next_res;
    logic next_done;
    
    
    // Registered addition logic
    always_ff @(posedge clk) begin
    
        if (rst) begin
            res <= '0;  // Reset to 0
            done <= 0;
        end 
        
        else begin
            res <= next_res;  
            done <= next_done;
        end
    end

    
    always_comb begin
        
        next_done = 1;
        
        if(func == 1'b0)
            next_res = a + b;
        else
            next_res = a - b; 

    end
    
    
endmodule



interface int_prac_if;
  logic clk;
  logic rst;
  logic [4:0] a, b;
  logic func;
  logic [7:0] res;
  logic done;
endinterface

