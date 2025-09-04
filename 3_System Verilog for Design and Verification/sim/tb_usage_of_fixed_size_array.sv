`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 09:26:12 AM
// Design Name: 
// Module Name: tb_usage_of_fixed_size_array
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


module tb_usage_of_fixed_size_array();

class Transaction;
    rand bit [7:0] din;
    randc bit [7:0] addr;
    bit wr;                  // read and write 0 and 1 respectively
    bit [7:0] dout;
    
    constraint addr_c {addr > 10; addr< 18;};
 
endclass
 
class Generator;
 
    Transaction t;
    integer i;
    
    task run();
        for(int i = 0; i < 100; i++) begin
            t = new();       // Done for all the instances of a class
            t.randomize();  //
        end
    endtask
    
endclass


class Scoreboard;
    bit [7:0] tarr [256] = '{default:0};  // Since addr can hold 256 combinations we are creating thisb array
    Transaction t;
    
    task run();
        
        if(t.wr == 1'b1) begin
            tarr[t.addr] = t.din;
            $display("[SCO] : Data stored din: %0d, addr : %0d", t.din, t.addr);
        end
        
        if(t.wr == 1'b0) begin
            if(t.dout == 0)
                $display("[SCO] : No Data Written at this location. Test Passed");
            else if (t.dout == tarr[t.addr])
                $display("[SCO] : Valid Data Found. Test Passed");
            else
                $display("[SCO] : Test Failed");
        end
        
    endtask
endclass    
endmodule
