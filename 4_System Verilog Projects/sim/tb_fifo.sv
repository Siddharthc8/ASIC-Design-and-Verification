`timescale 1ns / 1ps

module tb_fifo();

//.....................................
class Transaction;
    
   rand bit oper;         // To decide to read or write
   bit rd, wr;
   bit [7:0] data_in;
   bit [7:0] data_out;
   bit empty, full;
   
   constraint oper_ctrl { oper dist { 1 :/ 50, 0:/ 50}; 
                        }
   
endclass

//...........................................
class Generator;
    
    Transaction tr;
    mailbox #(Transaction) mbx;
    int count = 0;     // Number of iterations
    int i = 0;     // Current iteration
    
    event next;
    event done; 
    
    function new (mailbox #(Transaction) mbx);
        this.mbx = mbx;
        tr = new();
    endfunction
    
    task run();
        repeat(count) begin
            assert (tr.randomize) else $error("Randomization Failed");
            i++;    
            mbx.put(tr);
            $display("[GEN] : oper: %0d, iteration: %0d", tr.oper, i);
            @(next);           // Blocking so won't proceed until scoreboard has finished
        end
        -> done;
    endtask   

endclass

//..........................................
class Driver;    
    
    virtual fifo_if fif;
    
    Transaction datac;
    mailbox #(Transaction) mbx;
    
    function new (mailbox #(Transaction) mbx);
        this.mbx = mbx;
    endfunction
    
    task reset();
        fif.rst <= 1'b1;
        fif.rd <= 1'b0;
        fif.wr <= 1'b0;
        fif.data_in <= 0;
        repeat(5) @(posedge fif.clock);
        fif.rst <= 1'b0;
        $display("[DRV] : DUT Reset done");
    endtask
    
    task write();
        @(posedge fif.clock);
        fif.rst <= 1'b0;
        fif.rd <= 1'b0;
        fif.wr <= 1'b1;
        fif.data_in <= $urandom_range(1,10);                 // Apply first and then wait
        @(posedge fif.clock);
        fif.wr <= 1'b0;
        $display("[DRV] : Data write data: %0d", fif.data_in);
        @(posedge fif.clock);
    endtask
    
    task read();
        @(posedge fif.clock);
        fif.rst <= 1'b0;
        fif.rd <= 1'b1;
        fif.wr <= 1'b0;
        @(posedge fif.clock);
        fif.wr <= 1'b0;
        $display("[DRV] : Data read");
        @(posedge fif.clock);
    endtask
    
    task run();
        forever begin
            mbx.get(datac);
            if(datac.oper == 1'b1)
                write();
            else
                read();
        end
    endtask

endclass 


class Monitor;
    
    virtual fifo_if fif;
    
    Transaction tr;
    mailbox #(Transaction) mbx;
    
    
    function new(mailbox #(Transaction) mbx);
        this.mbx = mbx;
    endfunction
    
    task run();
        tr = new();
        
        forever begin
            repeat(2) @(posedge fif.clock);    // Wait first and then receive
            tr.wr = fif.wr;
            tr.rd = fif.rd;
            tr.data_in = fif.data_in;
            tr.full = fif.full;
            tr.empty = fif.empty;
            @(posedge fif.clock);
            tr.data_out = fif.data_out;
            
            mbx.put(tr);
            $display("[MON] : wr:%0d, rd:%0d, data_in:%0d, data_out:%0d, full:%0d, empty:%0d", tr.wr, tr.rd, tr.data_in, tr.data_out, tr.full, tr.empty);
        end
    endtask
endclass


class Scoreboard;

    Transaction tr;
    mailbox #(Transaction) mbx;
    event next;
    
    bit [7:0] din[$];              // Queue
    bit [7:0] temp;
    int err = 0;
    
    function new(mailbox #(Transaction) mbx);
        this.mbx = mbx;
    endfunction
    
    task run();
        
        forever begin
            mbx.get(tr);
            $display("[SCO]: wr:%0d, rd:%0d, data_in:%0d, data_out:%0d, full:%0d, empty:%0d", tr.wr, tr.rd, tr.data_in, tr.data_out, tr.full, tr.empty);
            
            // Write Condition
            if(tr.wr == 1'b1) begin
                if(tr.full == 1'b0) begin
                    din.push_front(tr.data_in);
                    $display("[SCO]: Data stored in stack: %0d", tr.data_in);
                end
                else begin
                    $display("[SCO] : Fifo is full");
                end
                $display("----------------------------------");
            end
            
            // Read Condition
            if(tr.rd == 1'b1) begin
                if(tr.empty == 1'b0) begin
                    temp = din.pop_back();
                    if(tr.data_out == temp) 
                        $display("[SCO]: Data Match");
                    else begin
                        $display("[SCO]: Data Mismatch");
                        err++;
                    end
                end
                else begin
                    $display("[SCO]: Fifo is empty");
                end
                $display("----------------------------------");
            end
            
            
            -> next;
        end
    endtask
    
endclass

    
class Environment;
    
    virtual fifo_if fif;
    
    Generator gen;
    Driver drv;
    Monitor mon;
    Scoreboard sco;
    
    event nextgs;  // gen -> sco
    
    mailbox #(Transaction) gdmbx;        // GEN to DRV
    mailbox #(Transaction) msmbx;        // MON to SCO
    
    function new(virtual fifo_if fif);   // Don't forget to add virtual
        gdmbx = new();
        gen = new(gdmbx);
        drv = new(gdmbx);        
        
        msmbx = new();
        mon = new(msmbx);
        sco = new(msmbx);
        
        this.fif = fif;
        drv.fif = this.fif;
        mon.fif = this.fif;
        
        gen.next = nextgs;
        sco.next = nextgs;
                
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
        wait(gen.done.triggered);
        $display("----------------------------------");
        $display("Error Count : %0d", sco.err);
        $display("----------------------------------");
        $finish;
    endtask
  
    task run();
        pre_test();
        test();
        post_test();
    endtask

endclass




    fifo_if fif();
    
    fifo dut(fif.clock, fif.rst, fif.wr, fif.rd, fif.data_in, fif.data_out, fif.empty, fif.full);
    
    initial begin
        fif.clock <= 0;
    end
    
    always #10 fif.clock <= ~fif.clock;
    
    Environment env;
    
    initial begin
        env = new(fif);
        env.gen.count = 10;    // Number of iterations
        env.run();
    end
    
    initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end

endmodule
