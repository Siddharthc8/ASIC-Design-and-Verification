`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2024 07:42:49 PM
// Design Name: 
// Module Name: tb_transaction_class_eg_fifo
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


module tb_transaction_class_eg_fifo();

class Transaction;
    
    bit clk;
    bit rst;
    
    rand bit wreq, rreq;
    rand bit [7:0] wdata;
    
    bit [7:0] rdata;
    bit e; 
    bit f;
    
    constraint ctrl_wr { wreq dist { 0 := 30, 1 := 70};
    }
    
    constraint ctrl_rd { rreq dist { 0 := 70, 1 := 30 };
    }
    
    constraint wr_rd   { wreq != rreq;
    }
    
endclass



endmodule
