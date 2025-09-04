`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2024 12:56:12 AM
// Design Name: 
// Module Name: tb_scratch1
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


module tb_scratch1();   // tb_a71

interface add_if;
    logic [3:0] a;
    logic [3:0] b;
    logic [4:0] sum;
    logic clk;
    
    // This shows that "a" and "b" will be driven out from the driver class
    modport DRV (output a,b, input sum,clk); // Just like a function where and b are exiting from Driver class

endinterface

//.....................................
class Transaction;
    
   randc bit [3:0] a;
   randc bit [3:0] b;
   bit [4:0] sum;
   
   function void display();
    $display(" a: %0d, b: %0d, sum: %0d", a, b, sum);  // y is output so not triggered
   endfunction
   
   function Transaction copy();
       copy = new();
       copy.a = this.a;
       copy.b = this.b;
       copy.sum = this.sum;
   
   endfunction
   
endclass

//...........................................
class Generator;
    
    Transaction trans;
    mailbox #(Transaction) mbx;
    event done; 
    event next;
          
    function new (mailbox #(Transaction) mbx);
        this.mbx = mbx;
        trans = new();
    endfunction
    
    task run();
        
        for(int i=0; i<5; i++) begin

            assert(trans.randomize()) else $display("Randomization Failed");
            mbx.put(trans.copy());    // Sending the copy so randc can cycle within the range
            $display("\n[GEN}  data->  [DRV]");
            trans.display();
            @(next);           // Blocking so won't proceed until scoreboard has finished
        end
        -> done;
    endtask   

endclass

//..........................................
class Driver;
    
    //  The interface MODPORT restriction is applies as .DRV in the next line
    virtual add_if .DRV aif;    // Calling an interface in a class doesn't require braces n the end
    
    Transaction trans_drv;
    mailbox #(Transaction) mbx;
    
    
    function new (mailbox #(Transaction) mbx);
        this.mbx = mbx;
    endfunction
    
    task run();
        forever begin
            mbx.get(trans_drv);
            $display("[DRV] -> [DUT]/INT"); 
            trans_drv.display();     
            
            aif.a = trans_drv.a;
            aif.b = trans_drv.b;
            @(posedge aif.clk);
        end
    endtask

endclass 


class Monitor;

    Transaction trans_mon;
    mailbox #(Transaction) mbx;
    virtual add_if aif;
    
    
    function new(mailbox #(Transaction) mbx);
        this.mbx = mbx;
        trans_mon = new();
    endfunction
    
    task run();
        forever begin
            
            $display("[MON] -> [SCO]");
            trans_mon.display();
            
            repeat(2) @(posedge aif.clk);
            trans_mon.a = aif.a;
            trans_mon.b = aif.b;
            trans_mon.sum = aif.sum;
            
            mbx.put(trans_mon);
        end
    endtask
endclass


class Scoreboard;

    Transaction trans_sco;
    mailbox #(Transaction) mbx;
    event next;
    
    function new(mailbox #(Transaction) mbx);
        this.mbx = mbx;
    endfunction
    
    task compare(input Transaction trans_sco);
        if((trans_sco.sum) == (trans_sco.a + trans_sco.b))
            $display("[SCO]: Results Match");
        else
            $display("[SCO]: Results Mismatch");
    endtask
    
    task run();
        forever begin
            mbx.get(trans_sco);
            $display("[SCO] <- [MON]");
            trans_sco.display();
            compare( trans_sco );
            -> next;
        end
    endtask
    
endclass

    
//.....................................MAIN MODULE......................................//

//......CLOCK GENERATION AND INTERFACE DECLARATION...................//

    add_if aif();    // Braces needed at the end if calling in testbench top
    
    add dut (
        .a(aif.a),
        .b(aif.b),
        .sum(aif.sum),
        .clk(aif.clk)
        );
    
    localparam T = 20;  // Clock Period
    initial begin
        aif.clk <= 0;
    end
    
    always #(T/2) aif.clk <= ~aif.clk;

//......................................
    
    mailbox #(Transaction) mbx;
    Generator gen;
    Driver drv;
    Monitor mon;
    Scoreboard sco;
    event done;
    event next;
    
    initial begin
        mbx = new();     // Don't forget this part
        gen = new(mbx);
        drv = new(mbx);
        mon = new(mbx);
        sco = new(mbx);
        
        drv.aif = aif;  // Diver class interface = aif in tb top
        mon.aif = aif;
        
        next = gen.next;
        next = sco.next; 
        // Display command won't work here as run task in driver is a forever loo[p so only exits with $finish command
    end
    
    initial begin
        fork          // To execute them in parallel
            gen.run();
            drv.run();
            mon.run();
            sco.run();            
        join_none           // Non-blocking so it does not wait for the completion of the fork methods
            wait(done.triggered);
            $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;

    end

endmodule
