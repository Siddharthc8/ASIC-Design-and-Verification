`timescale 1ns / 1ps

// NOTE: The default value for any logic type variable is x so we are using that to our adavanatage

module tb_a11;
//.....................................
class Transaction;
    
   randc logic din;
   logic dout;
   
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
//            assert(tr.din == 1'bx) else $display("Randomization Failed");
//            assert(tr.randomize) else $display("Randomization Failed");
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
    
    virtual dff_if vif;
    
    Transaction tr;
    mailbox #(Transaction) mbx;
    
    function new (mailbox #(Transaction) mbx);
        this.mbx = mbx;
    endfunction
    
    task reset();
        vif.rst <= 1'b1;
        repeat(5) @(posedge vif.clk);
        vif.rst <= 1'b0;
        @(posedge vif.clk);
        $display("[DRV] : Reset done");
    endtask
    
    task run();
        forever begin
            mbx.get(tr);
            vif.din <= tr.din;                 // Apply first and then wait
            @(posedge vif.clk);
            tr.display("DRV");
            vif.din <= 1'b0;
            @(posedge vif.clk);
        end
    endtask

endclass 


class Monitor;
    
    virtual dff_if vif;
    
    Transaction tr;
    mailbox #(Transaction) mbx;
    
    
    function new(mailbox #(Transaction) mbx);
        this.mbx = mbx;
        tr = new();    // Usually in task run 
    endfunction
    
    task run();
        forever begin
            repeat(2) @(posedge vif.clk);    // Wait first and then receive
            tr.dout = vif.dout;
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
            trref.display("SCO");
            tr.display("SCO");
            if ((tr.dout == trref.din) || (tr.dout == 1'b0 && trref.din === 1'bx))
                $display("[SCO]: Results Match");
//            else if 
//                $display("[SCO]: Results Match");
            else
                $display("[SCO]: Results Mismatch");
        $display("----------------------------------");
        -> sconext;
        end
    endtask
    
endclass

    
class Environment;
    
    virtual dff_if vif;
    
    Generator gen;
    Driver drv;
    Monitor mon;
    Scoreboard sco;
    event done;
    event next;  // gen -> sco
    
    mailbox #(Transaction) gdmbx;        // GEN to DRV
    mailbox #(Transaction) msmbx;        // MON to SCO
    mailbox #(Transaction) mbxref;       // REFERENCE
    
    function new(virtual dff_if vif);   // Don't forget to add virtual
        gdmbx = new();
        msmbx = new();
        mbxref = new();
        
        gen = new(gdmbx, mbxref);
        drv = new(gdmbx);
        mon = new(msmbx);
        sco = new(msmbx, mbxref);
        
        this.vif = vif;
        drv.vif = vif;
        mon.vif = vif;
        
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



    dff_if vif();
    
    dff dut(vif);
    
    localparam T = 20;
    initial vif.clk <= 0;
    always #(T/2) vif.clk <= ~vif.clk;
    
    Environment env;
    
    initial begin
        env = new(vif);
        env.gen.count = 30;    // Number of iterations
        env.run();
    end
    

endmodule