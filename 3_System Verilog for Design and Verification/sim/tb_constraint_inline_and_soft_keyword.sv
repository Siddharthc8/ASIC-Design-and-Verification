`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2025 10:00:00 AM
// Design Name: 
// Module Name: tb_constraint_inline_and_soft_keyword
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


module tb_constraint_inline_and_soft_keyword();

class constraints;

rand int addr, data;

constraint addata_c1 { soft addr < 50; data > 100;}  // Global constraints
constraint addata_c2 { soft addr > 50; data < 500; }      // Global constraints

endclass

constraints con;

initial begin
    
    for(int i = 0; i < 10; i++ ) begin
        con = new();
        con.addata_c2.constraint_mode(0);
        con.randomize() with { addr > 50; data < 100; };
        $display("Addr: %0d, Data: %0d", con.addr, con.data);
        #1;
    end

end



endmodule
