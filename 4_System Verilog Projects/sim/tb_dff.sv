`timescale 1ns / 1ps

module tb_dff;
//.....................................
class Transaction;
    
   randc bit din;
   bit dout;
   
   function Transaction copy();
       copy = new();
       copy.din = this.din;
       copy.dout = this.dout;
   endfunction
   
   function void display(input string tag);
    $display("[%0s] din: %0b, dout: %0b", tag, din, dout);  
   endfunction
   
endclass

//...........................................
class Generator;
    
    Transaction tr;
    mailbox #(Transaction) mbx;
    mailbox #(Transaction) mbxref;
    event done; 
    event sconext;
    int count;
          
    function new (mailbox #(Transaction) mbx, mailbox #(Transaction) mbxref );
        this.mbx = mbx;
        this.mbxref = mbxref;
        tr = new();
    endfunction
    
    task run();
        repeat(count) begin
            assert(tr.randomize()) else $display("Randomization Failed");
            mbx.put(tr.copy());    
            mbxref.put(tr.copy());
            tr.display("GEN");
            @(sconext);           // Blocking so won't proceed until scoreboard has finished
        end
        -> done;
    endtask   

endclass

//..........................................
class Driver;    
    
    virtual dff_if uif;
    
    Transaction tr;
    mailbox #(Transaction) mbx;
    
    function new (mailbox #(Transaction) mbx);
        this.mbx = mbx;
    endfunction
    
    task reset();
        uif.rst <= 1'b1;
        repeat(5) @(posedge uif.clk);
        uif.rst <= 1'b0;
        @(posedge uif.clk);
        $display("[DRV] : Reset done");
    endtask
    
    task run();
        forever begin
            mbx.get(tr);
            uif.din <= tr.din;                 // Apply first and then wait
            @(posedge uif.clk);
            tr.display("DRV");
            uif.din <= 1'b0;
            @(posedge uif.clk);
        end
    endtask

endclass 


class Monitor;
    
    virtual dff_if uif;
    
    Transaction tr;
    mailbox #(Transaction) mbx;
    
    
    function new(mailbox #(Transaction) mbx);
        this.mbx = mbx;
        tr = new();    // Usually in task run 
    endfunction
    
    task run();
        forever begin
            repeat(2) @(posedge uif.clk);    // Wait first and then receive
            tr.dout = uif.dout;
            mbx.put(tr);
            tr.display("MON");
        end
    endtask
endclass


class Scoreboard;

    Transaction tr;
    Transaction trref;
    mailbox #(Transaction) mbx;
    mailbox #(Transaction) mbxref;
    event sconext;
    
    function new(mailbox #(Transaction) mbx, mailbox #(Transaction) mbxref);
        this.mbx = mbx;
        this.mbxref = mbxref;
    endfunction
    
    task run();
        forever begin
            mbx.get(tr);
            mbxref.get(trref);
            tr.display("SCO");
            trref.display("SCO");
            if(tr.dout == trref.din)
            $display("[SCO]: Results Match");
        else
            $display("[SCO]: Results Mismatch");
        $display("----------------------------------");
        -> sconext;
        end
    endtask
    
endclass

    
class Environment;
    
    virtual dff_if uif;
    
    Generator gen;
    Driver drv;
    Monitor mon;
    Scoreboard sco;
    event done;
    event next;  // gen -> sco
    
    mailbox #(Transaction) gdmbx;        // GEN to DRV
    mailbox #(Transaction) msmbx;        // MON to SCO
    mailbox #(Transaction) mbxref;       // REFERENCE
    
    function new(virtual dff_if uif);   // Don't forget to add virtual
        gdmbx = new();
        msmbx = new();
        mbxref = new();
        
        gen = new(gdmbx, mbxref);
        drv = new(gdmbx);
        mon = new(msmbx);
        sco = new(msmbx, mbxref);
        
        this.uif = uif;
        drv.uif = uif;
        mon.uif = uif;
        
        gen.done = done;
        gen.sconext = next;
        sco.sconext = next;
    endfunction
    
    task pre_test();
        drv.reset();
    endtask
    
    task test();
        fork
         gen.run();
         drv.run();
         mon.run();
         sco.run();   
        join_any
    endtask
    
    task post_test();
        wait(done.triggered);
        $finish;
    endtask
  
    task run();
        pre_test();
        test();
        post_test();
    endtask

endclass

//............MAIN MODULE.............//

    dff_if uif();
    
    dff dut(uif);
    
    localparam T = 20;
    initial uif.clk <= 0;
    always #(T/2) uif.clk <= ~uif.clk;
    
    Environment env;
    
    initial begin
        env = new(uif);
        env.gen.count = 30;    // Number of iterations
        env.run();
    end
    

endmodule
