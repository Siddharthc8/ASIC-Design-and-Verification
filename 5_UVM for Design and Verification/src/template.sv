`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2025 02:06:38 PM
// Design Name: 
// Module Name: template
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


module template(

    input logic [3:0] a, b,
    input logic clk, rst,
    output logic add_flag, mul_flag,        // (Flags)
    output logic [7:0] out,
    output logic [4:0] aout,
    output logic [7:0] mout,    
    output logic done
    
    );
    
    typedef enum logic [1:0] { add, mul } oper_type;
    oper_type oper;
    
    
    always @(posedge clk)
    begin
        if(rst)
        begin
            aout <= 0;
            mout <= 0;
        end
        else
        begin
            case (oper)
            add : begin out <= a + b;
                  add_flag <= 1;
                  end
            mul : begin out <= a * b;
                  mul_flag <= 1;
                  end
            endcase
            
        end
    end
    
    always@(negedge clk)
    begin
        add_flag <=  0;
        mul_flag <= 0;
    end

//    dummy_add (.a(aa),.b(ab), .clk(clk), .rst(rst), .aout(aout));
//    dummy_mul (.a(ma),.b(mb), .clk(clk), .rst(rst), .mout(mout));
  
endmodule

module template_add(  
    
    input logic [3:0] a,b,
    input logic clk, rst,
    output logic [4:0] aout
    
    );
    
    always @(posedge clk)
    begin
        if(rst)
            aout <= 0;
        else
            aout <= a + b;
    end

endmodule

module template_mul ( 

    input logic [3:0] a,b,
    input logic clk, rst,
    output logic [7:0] mout
    
    );
    
    always @(posedge clk)
    begin
        if(rst)
            mout <= 0;
        else
            mout <= a * b;
    end

endmodule

interface template_if;
  
//  Enumerated data-type
  oper_type oper;
  
// For add
  logic [3:0] aa, ab;
  logic clk, rst;
  logic [4:0] add_out;
  logic add_flag;
  
// For mul
  logic [3:0] ma, mb;
  logic clk, rst;
  logic [7:0] mul_out;
  logic mul_flag;
  
  // General
  logic [7:0] out;
  
endinterface
