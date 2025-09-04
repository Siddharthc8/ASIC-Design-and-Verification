`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2024 07:06:11 PM
// Design Name: 
// Module Name: tb_a72
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


module tb_a72();

//.................................................
interface add_if;
    logic [3:0] a;
    logic [3:0] b;
    logic [4:0] res;
    logic clk;
    
    // This shows that "a" and "b" will be driven out from the driver class
//    modport DRV (output a,b, input res,clk); // Just like a function where and b are exiting from Driver class

endinterface

//.....................................
class Transaction;
    
   randc bit [3:0] a;
   randc bit [3:0] b;
   bit [4:0] res;
   
   function void display();
    $display(" a: %0d, b: %0d, res: %0d", a, b, res);  // y is output so not triggered
   endfunction
   
   function Transaction copy();
       copy = new();
       copy.a = this.a;
       copy.b = this.b;
       copy.res = this.res;
   
   endfunction
   
endclass

//.................................................................................
class Monitor;
    
    mailbox #(Transaction) mbx;
    Transaction trans_mon;
    virtual add_if aif;
    
    function new(mailbox #(Transaction) mbx);
        this.mbx = mbx;
        trans_mon = new();
    endfunction
    
    task run();
        forever begin
            
            repeat(2) @(posedge aif.clk);
            trans_mon.a = aif.a;
            trans_mon.b = aif.b;
            trans_mon.res = aif.res;
            
            mbx.put(trans_mon);
            $display("\n[MON] -> [SCO]");
            trans_mon.display();
            
        end
    endtask
            
endclass

//.............................................................................
class Scoreboard;
    
    mailbox #(Transaction) mbx;
    Transaction trans_sco;
    
    function new(mailbox #(Transaction) mbx);
        this.mbx = mbx;
        trans_sco = new();
    endfunction
    
    task compare(input Transaction trans_sco);
        if((trans_sco.res) == (trans_sco.a + trans_sco.b))
            $display("[SCO]: Results Match");
        else
            $error("[SCO]: Results Mismatch");
    endtask
    
    task run();
    
        forever begin
            
            mbx.get(trans_sco);
            $display("[SCO]");
            trans_sco.display();
            compare( trans_sco );
            #40;
               
        end
    endtask
    
endclass

    
//.....................................MAIN MODULE......................................//

//......CLOCK GENERATION AND INTERFACE DECLARATION...................//

    add_if aif();    // Braces needed at the end if calling in testbench top
    
    multiplier_nbit dut (
        .a(aif.a),
        .b(aif.b),
        .res(aif.res),
        .clk(aif.clk)
        );
    
    localparam T = 20;  // Clock Period
    initial begin
        aif.clk <= 0;
    end
    
    always #(T/2) aif.clk <= ~aif.clk;

//......................................
    
    Monitor mon;
    Scoreboard sco; 
    mailbox #(Transaction) mbx;
    
    initial begin
        
        for(int i=0; i<20; i++) begin
            
            repeat(2) @(posedge aif.clk);
            aif.a <= $urandom_range(0,15);
            aif.b <= $urandom_range(0,15);
            $display("a: %0d, b: %0d", aif.a, aif.b);
        end

    end
    
    initial begin
        mbx = new();
        mon = new(mbx);
        sco = new(mbx);
        mon.aif = aif;
        
        fork 
            mon.run();
            sco.run();
        join        
    end
    
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        #450;
        $finish;

    end

endmodule