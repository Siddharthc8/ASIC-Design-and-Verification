`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////

module tb_a41_top();

class Transaction;
    
    typedef enum bit { write = 1'b0, read = 1'b1} oper_type;
    
    rand oper_type oper;
    
    bit rx;
    rand bit [7:0] dintx;
    bit newd;
    bit tx;
    bit [7:0] doutrx;
    
    bit donetx;
    bit donerx;
    
    function Transaction copy();
        copy = new();
        copy.rx  =  this.rx;
        copy.dintx = this.dintx;
        copy.newd  =  this.newd;
        copy.tx = this.tx;
        copy.doutrx = this.doutrx;
        copy.donetx = this.donetx;
        copy.donerx = this.donerx;
        copy.oper = this.oper;
    endfunction
    
    constraint write_ctrl { oper dist {0 :/ 70, 1 :/ 30}; }

endclass

////////////////////////////////////////////////////////

class Generator;
    
    int count = 0;
    Transaction tr;
    mailbox #(Transaction) mbx;
    event done;
    event drvnext;
    event sconext;
    
    function new(mailbox #(Transaction) mbx);
        tr = new();
        this.mbx = mbx;
    endfunction
    
    task run();
        repeat(count) begin
            assert(tr.randomize) else $error("[GEN] :Randomization Failed");
            mbx.put(tr.copy);
            $display("[GEN] : Oper : %0s, din : %0d", tr.oper.name(),tr.dintx);
            @(drvnext);
            @(sconext);
        end
        ->done;
    
    endtask
    
endclass

////////////////////////////////////////////////////////

class Driver;
    
    virtual a41_if vif;
    Transaction tr;
    mailbox #(Transaction) mbx;
    mailbox #(bit [7:0]) mbxds;
    event drvnext;
    
    bit [7:0] datarx;
//    bit wr = 0;
    bit [7:0] din;
    
    function new(mailbox #(Transaction) mbx, mailbox #(bit [7:0]) mbxds);
//        tr = new();
        this.mbx = mbx;
        this.mbxds = mbxds;
    endfunction
    
    task reset();
        vif.rst <= 1'b1;
        vif.newd <= 0;
        vif.rx <= 1'b1;
        vif.dintx <= 0;
        repeat(5) @(posedge vif.uclktx);
        vif.rst <= 1'b0;
        @(posedge vif.uclktx);
        $display("[DRV] : RESET DONE");
        $display("-----------------------------------------");
    endtask
    
    task run();
        forever begin
            mbx.get(tr);
            
            if(tr.oper == 1'b0) begin      // Write
                @(posedge vif.uclktx);
                vif.rst <= 1'b0; 
                vif.newd <= 1'b1;
                vif.rx <= 1'b1;  
                vif.dintx <= tr.dintx;
                @(posedge vif.uclktx);
                vif.newd <= 1'b0;
                mbxds.put(tr.dintx);
                $display("[DRV] : Ref sent data: %0d", tr.dintx);
                wait(vif.donetx == 1'b1);
                ->drvnext;
            end
            
            else if(tr.oper == 1'b1) begin   // Read 
                @(posedge vif.uclkrx);
                vif.rst <= 1'b0; 
                vif.newd <= 1'b0; 
                vif.rx <= 1'b0;       // 0 indicates start
                @(posedge vif.uclkrx);
                
                for(int i=0; i<=7; i++) begin 
                    @(posedge vif.uclkrx);
                    vif.rx <= $urandom;
                    datarx[i] = vif.rx;
                end
                
                mbxds.put(datarx);
                
                $display("[DRV] : Ref rcvd data : %0d", datarx);
                wait(vif.donerx == 1'b1);
                vif.rx <= 1'b1;
                ->drvnext;
            end
        end
    endtask
    
endclass

////////////////////////////////////////////////////////

class Monitor;
    
    virtual a41_if vif;
    Transaction tr;
    mailbox #(bit [7:0]) mbx;
    mailbox #(bit) mbxt;
    bit [7:0] srx;
    bit [7:0] rrx;
    bit parity;
    
    function new(mailbox #(bit [7:0]) mbx, mailbox #(bit) mbxt);
//        tr = new();
        this.mbx = mbx;
        this.mbxt = mbxt;
    endfunction
    
    task run();
        forever begin
            @(posedge vif.uclktx);
            
            if((vif.newd == 1'b1) && (vif.rx == 1'b1)) begin
                @(posedge vif.uclktx); 
                for(int i=0; i<=8; i++) begin
                    @(posedge vif.uclktx);
                    if(i == 8)
                        parity = vif.tx;
                    else
                        srx[i] = vif.tx;
                end
            $display("[MON] : Data sent from UART tx: %0d, parity : %0d", srx, parity); 
            @(posedge vif.uclktx);
            mbx.put(srx);  
            mbxt.put(parity);
            end
            
            else if((vif.newd == 1'b0) && (vif.rx == 1'b0)) begin
                wait(vif.donerx == 1);
                rrx = vif.doutrx;
                $display("[MON] : Data rcvd from UART rx: %0d", rrx);
                @(posedge vif.uclkrx);
                mbx.put(rrx); 
                mbxt.put(parity);                    
            end
        end
    endtask

endclass

////////////////////////////////////////////////////////

class Scoreboard;
    
    Transaction tr;
    mailbox #(bit [7:0]) mbxms, mbxds;
    mailbox #(bit) mbxt;
    event sconext;
    
    bit [7:0] ms;
    bit [7:0] ds;
    bit parity;
    
    function new(mailbox #(bit [7:0]) mbxms, mailbox #(bit [7:0]) mbxds, mailbox #(bit) mbxt);
        this.mbxds = mbxds;
        this.mbxms = mbxms;
        this.mbxt = mbxt;
    endfunction
    
    task run();
        forever begin
            mbxms.get(ms);
            mbxds.get(ds);
            mbxt.get(parity);
            
            $display("[SCO] : DRV(ref) : %0d, MON(og) : %0d", ds, ms);
            $display("[SCO] : Parity : %0d", parity);
            if(ds == ms)
                $display("DATA MATCHED");
            else
              $display("DATA MISMATCHED");                             
            
            $display("------------------------------------");
        
            ->sconext;
        end
    endtask
    
endclass

////////////////////////////////////////////////////////

class Environment;
    
    virtual a41_if vif;
    
    Generator gen;
    Driver drv;
    Monitor mon;
    Scoreboard sco;
    
    mailbox #(Transaction) mbxgd;
    mailbox #(bit [7:0]) mbxds;
    mailbox #(bit [7:0]) mbxms;
    mailbox #(bit) mbxt;
    
    event nextgd;
    event nextgs;
    
    function new(virtual a41_if vif);
        
        mbxgd = new();
        mbxms = new();
        mbxds = new();
        mbxt = new();
        
        gen = new(mbxgd);
        drv = new(mbxgd, mbxds);
        mon = new(mbxms, mbxt);
        sco = new(mbxms, mbxds, mbxt);
        
        this.vif = vif;
        drv.vif = this.vif;
        mon.vif = this.vif;
        
        gen.drvnext = nextgd;
        drv.drvnext = nextgd;
        
        gen.sconext = nextgs;
        sco.sconext = nextgs;
        
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
        $finish;
    endtask
    
    task run();
        pre_test();
        test();
        post_test();
    endtask

endclass


///...................MAIN MODULE................/////

    a41_if vif();
    
    a41_top #(1000000, 9600) dut(
        vif.clk,
        vif.rst,
        vif.rx,
        vif.dintx,
        vif.newd,
        vif.tx,
        vif.doutrx,
        vif.donetx,
        vif.donerx
    );
    
    initial vif.clk <= 0;   
    
    
    always #10 vif.clk <= ~vif.clk;
    
    Environment env;
    
    initial begin
        env = new(vif);
        env.gen.count = 10;
        env.run();
    end  
    
    initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    end
    
    assign vif.uclktx = dut.utx.uclk; 
    assign vif.uclkrx = dut.rtx.uclk;
    
endmodule