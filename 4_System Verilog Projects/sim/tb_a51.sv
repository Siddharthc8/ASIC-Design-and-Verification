
module tb_a51;

/////////////////////////Transaction
class transaction;
  
  bit newd;
  rand bit op;
  rand bit [7:0] din;
  rand bit [6:0] addr;
  bit [7:0] dout;
  bit done;
  bit busy;
  bit ack_err;
  
  constraint addr_c { addr > 1; addr < 5; din > 1; din < 10; }
  
  
  constraint rd_wr_c {
    op dist {1 :/ 50 ,  0 :/ 50};
  }
  
  
endclass
 
/////////////////////////Generator
 
class generator;
  
  transaction tr;
  mailbox #(transaction) mbxgd;
  event done; ///gen completed sending requested no. of transaction
  event drvnext; /// dr complete its wor;
  event sconext; ///scoreboard complete its work
 
   int count = 0;
  
  function new( mailbox #(transaction) mbxgd);
    this.mbxgd = mbxgd;   
    tr =new();
  endfunction
  
    task run();
    
    repeat(count) begin
      assert(tr.randomize) else $error("Randomization Failed");
      //tr.addr = 7'h12;
      //tr.din  = 8'hff;
      mbxgd.put(tr);
      $display("[GEN]: op :%0d, addr : %0d, din : %0d", tr.op, tr.addr, tr.din);
      @(drvnext);
      @(sconext);
    end
    -> done;
  endtask
  
   
endclass
 
 
///////////////////////////////Driver
 
 
class driver;
  
  virtual a51_if vif;
  
  transaction tr;
  
  event drvnext;
  
  mailbox #(transaction) mbxgd;
 
  
  function new( mailbox #(transaction) mbxgd );
    this.mbxgd = mbxgd; 
  endfunction
  
  //////////////////Resetting System
  task reset();
    vif.rst <= 1'b1;
    vif.newd <= 1'b0;
    vif.op <= 1'b0;
    vif.din <= 0;
    vif.addr  <= 0;
    repeat(10) @(posedge vif.clk);
    vif.rst <= 1'b0;
    $display("[DRV] : RESET DONE"); 
    $display("---------------------------------"); 
  endtask
  
  task write();
    vif.rst <= 1'b0;
    vif.newd <= 1'b1;
    vif.op <= 1'b0;
    vif.din <= tr.din;
    vif.addr  <= tr.addr;//7'h12;//;
    repeat(5) @(posedge vif.clk);
    vif.newd <= 1'b0;
    @(posedge vif.done);
    $display("[DRV] : OP: WR, ADDR:%0d, DIN : %0d", tr.addr, tr.din);    
    vif.newd <= 1'b0;
    
 
  endtask
  
   task read();
    vif.rst <= 1'b0;
    vif.newd <= 1'b1;
    vif.op <= 1'b1;
    vif.din <= 0;
    vif.addr  <= tr.addr;//7'h12;//tr.addr;
    repeat(5) @(posedge vif.clk);
    vif.newd <= 1'b0;
    @(posedge vif.done);
    $display("[DRV] : OP: RD, ADDR:%0d, DOUT : %0d", tr.addr, vif.dout);    
  endtask
  
  
  task run();
    tr = new();
    forever begin
      
      mbxgd.get(tr);
      
     if(tr.op == 1'b0)
       write();
      else
       read();
      
      ->drvnext;
    end
  endtask
  
    
  
endclass
 
 
 
/////////////////////////////////////
 
 
/* module tb;
   
  generator gen;
  driver drv;
  event next;
  event done;
  
  mailbox #(transaction) mbxgd;
  
  i2c_if vif();
  i2c_top dut (vif.clk, vif.rst,  vif.newd, vif.wr, vif.wdata, vif.addr, vif.rdata, vif.done);
 
  initial begin
    vif.clk <= 0;
  end
  
  always #5 vif.clk <= ~vif.clk;
  
  initial begin
 
    mbxgd = new();
    gen = new(mbxgd);
    drv = new(mbxgd);
    gen.count = 10;
    drv.vif = vif;
    
    drv.drvnext = next;
    gen.drvnext = next;
    
  end
  
  initial begin
    fork
      drv.reset();
      gen.run();
      drv.run();
    join_none  
    wait(gen.done.triggered);
    $finish();
  end
   
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;   
  end
 
   assign vif.sclk_ref = dut.e1.sclk_ref;
   
  
endmodule
 
*/
 
//////////////////////////////////////monitor
 
 
class monitor;
    
  virtual a51_if vif; 
  transaction tr;
  mailbox #(transaction) mbxms;
 
 
  
 
  
  function new( mailbox #(transaction) mbxms );
    this.mbxms = mbxms;
  endfunction
  
  
  task run();
    
    tr = new();
    
    forever 
    begin
      //@(posedge vif.clk);
      @(posedge vif.done);
      tr.din = vif.din;
      tr.addr = vif.addr;
      tr.op = vif.op;
      tr.dout = vif.dout;
      repeat(5) @(posedge vif.clk);
      mbxms.put(tr); 
      $display("[MON] op:%0d, addr: %0d, Wdin : %0d, Rdout:%0d", tr.op, tr.addr, tr.din, tr.dout);
     end
      
    
  endtask
  
endclass
///////////////////////////////////////////////////////////////
 
class scoreboard;
  
  transaction tr;
  
  mailbox #(transaction) mbxms;
  
  event sconext;
  
  bit [7:0] temp;  
  bit [7:0] mem[128] = '{default:0};
  
 
  
  function new( mailbox #(transaction) mbxms );
    this.mbxms = mbxms;
    
    for(int i = 0; i < 128; i++)
     begin
     mem[i] <= i;
     end
     
  endfunction
  
  
  task run();
 
    forever begin
      
      mbxms.get(tr);
      temp = mem[tr.addr];
                
      
      if(tr.op == 1'b0)
                begin   
                  mem[tr.addr] = tr.din;
                  $display("[SCO]: DATA STORED -> ADDR : %0d DATA : %0d", tr.addr, tr.din);
                  $display("-----------------------------------------------");
                end
       else 
                begin
                 
                  if( (tr.dout == temp))// || (tr.dout == tr.addr) )
                    $display("[SCO] :DATA READ -> Data Matched exp: %0d rec:%0d",temp,tr.dout);
                 else
                    $display("[SCO] :DATA READ -> DATA MISMATCHED exp: %0d rec:%0d",temp,tr.dout);
                         
                $display("-----------------------------------------------");
               end
  ->sconext;
    end 
  endtask
  
  
endclass
 
 
 
 
 
///////////////////////////////// Main Module /////////////////////
   
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;
  
  
  event nextgd;
  event nextgs;
 
  
  mailbox #(transaction) mbxgd, mbxms;
 
  
  a51_if vif();
  
  a51_top dut (vif.clk, vif.rst,  vif.newd, vif.op, vif.addr, vif.din, vif.dout, vif.busy, vif.ack_err, vif.done);
 
  initial begin
    vif.clk <= 0;
  end
  
  always #5 vif.clk <= ~vif.clk;
  
   initial begin
   
     
    mbxgd = new();
    mbxms = new();
    
    gen = new(mbxgd);
    drv = new(mbxgd);
    
    mon = new(mbxms);
    sco = new(mbxms);
 
    gen.count = 20;
  
    drv.vif = vif;
    mon.vif = vif;
    
    gen.drvnext = nextgd;
    drv.drvnext = nextgd;
    
    gen.sconext = nextgs;
    sco.sconext = nextgs;
  
   end
  
  task pre_test;
  drv.reset();
  endtask
  
  task test;
    fork
      gen.run();
      drv.run();
      mon.run();
      sco.run();
    join_any  
  endtask
  
  
  task post_test;
    wait(gen.done.triggered);
    $finish();    
  endtask
  
  task run();
    pre_test;
    test;
    post_test;
  endtask
  
  initial begin
    run();
  end
   
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();   
  end
   
endmodule