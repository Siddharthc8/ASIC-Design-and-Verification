`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2024 11:38:24 PM
// Design Name: 
// Module Name: tb_multiplier_nbit
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


module tb_multiplier_nbit();

localparam n = 4;

interface mult_if;
    
    logic clk; 
    logic rst;    
    logic [n-1:0] a;   
    logic [n-1:0] b;   
    logic [(2*n)-1:0] res;
    
    modport DRV (output rst,a, b, input clk);
endinterface


class Transaction;
    
    randc bit rst;
    randc bit [n-1:0] a;
    randc bit [n-1:0] b;
    bit [(2*n)-1:0] res;
    
    constraint rst_c { rst >= 0; rst <= 1; }
    
    function void display();
        $display("rst: %0d, a: %0d, b: %0d, res: %0d", rst, a, b, res);
    endfunction    
        
    function Transaction copy();
        copy = new();
        rst = this.rst;
        a = this.a;
        b = this.b;
        res = this.res;
    endfunction

endclass


class Generator;
    
    Transaction t;
    mailbox #(Transaction) mbx;
    event done;
    
    
    function new(mailbox #(Transaction) mbx);
        t = new();
        this.mbx = mbx;
    endfunction
    
    task run();
       for(int i = 0; i<20; i++) begin
           assert(t.randomize()) else $display("Randomization failed");
           mbx.put(t.copy());
           $display("[GEN] data--> [DRV]");
           t.display(); 
           #20;
       end
       -> done;
    endtask

endclass

class Driver;

    virtual mult_if .DRV mif;

    Transaction trans_drv;
    mailbox #(Transaction) mbx;
    
    function new(mailbox #(Transaction) mbx);
        this.mbx = mbx;
    endfunction
    
    task run();
        forever begin   
            mbx.get(trans_drv);
            $display("[GEN] <--data [DRV]");
            trans_drv.display();
            
            @(posedge mif.clk)
            mif.rst <= trans_drv.rst;
            mif.a <= trans_drv.a;
            mif.b <= trans_drv.b;
        end
    endtask

endclass


//............MAIN MODULE.............///

//  CLOCK GENRATION
    mult_if mif();
    
    multiplier_nbit #(.n(n)) dut(
        .clk(mif.clk),
        .rst(mif.rst),
        .a(mif.a),
        .b(mif.b),
        .res(mif.res)
    );
    
    localparam T = 20;
    
    initial mif.clk = 0;
    always #(T/2) mif.clk = !mif.clk;
    
    Generator gen;
    Driver drv;
    mailbox #(Transaction) mbx;
    event done;
    
    initial begin
        mbx = new();
        gen = new(mbx);
        drv = new(mbx);
        drv.mif = mif;
        done = gen.done;
        
    end
    initial begin
        fork 
            gen.run();
            drv.run();   
        join_any
            wait(done.triggered);
            $finish;
    
    end
    
endmodule
