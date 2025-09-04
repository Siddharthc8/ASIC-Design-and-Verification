`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2024 05:53:51 PM
// Design Name: 
// Module Name: dummy
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


module dummy(
    
    input logic [3:0] aa, ab, ma, mb,
    input logic clk, rst,
    output logic [4:0] aout,
    output logic [7:0] mout    
    
    );
    
//    typedef enum logic {add = 0, mul = 1} oper;
//    oper op;
//    always @(posedge clk)
//    begin
//        if(rst)
//        begin
//            aout <= 0;
//            mout <= 0;
//        end
//        else
//        begin
//            case (op)
//            add : aout <= aa + ab;
//            mul : mout <= ma * mb;
//            endcase
//        end
//    end

    dummy_add (.a(aa),.b(ab), .clk(clk), .rst(rst), .aout(aout));
    dummy_mul (.a(ma),.b(mb), .clk(clk), .rst(rst), .mout(mout));
  
endmodule

module dummy_add(  
    
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

module dummy_mul ( 

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

interface dadd_if;
  logic [3:0] aa, ab;
  logic clk, rst;
  logic [4:0] add_out;
endinterface

interface dmul_if;
  logic [3:0] ma, mb;
  logic clk, rst;
  logic [7:0] mul_out;
endinterface
