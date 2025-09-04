`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2024 05:09:09 PM
// Design Name: 
// Module Name: tb_a21_sol
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

module tb_a21_sol(); 

class transaction;
  
  rand bit oper;
  bit rd ,wr;
  bit [7:0] data_in;
  bit full, empty;
  bit [7:0] data_out;
  
constraint oper_ctrl {  
  oper dist {1 :/ 50 , 0:/ 50};
    
  }  
  
endclass


///////////////////////////////////////////////////


class generator;
  
   transaction tr;
   mailbox #(transaction) mbx;
  
  int count = 0;
  int i = 0;
  
   event next;  ///know when to send next transaction
   event done;  ////conveys completion of requested no. of transaction
   
   
  function new(mailbox #(transaction) mbx);
      this.mbx = mbx;
      tr=new();
   endfunction; 
  

   task run(); 
    
     repeat(count)	 
	     begin    
           assert(tr.randomize) else $error("Randomization failed");
           i++;
           mbx.put(tr);
           $display("[GEN] : Oper : %0d iteration : %0d", tr.oper, i);
           @(next);
         end 
     
     
     ->done;
   endtask
  
  
endclass
////////////////////////////////////////////
  
  
class driver;
  
   virtual fifo_if fif;
  
   mailbox #(transaction) mbx;
  
   transaction datac;
  
   event next;
   event done;
  int wcount = 0, rcount = 0;
  
   
 
    function new(mailbox #(transaction) mbx);
      this.mbx = mbx;
   endfunction; 
  
  ////reset DUT
  task reset();
    fif.rst <= 1'b1;
    fif.rd <= 1'b0;
    fif.wr <= 1'b0;
    fif.data_in <= 0;
    repeat(5) @(posedge fif.clock);
    fif.rst <= 1'b0;
    $display("[DRV] : DUT Reset Done");
    $display("------------------------------------------");
  endtask
   
  
  task write();
    @(posedge fif.clock);
    fif.rst <= 1'b0;
    fif.rd <= 1'b0;
    fif.wr <= 1'b1;
    fif.data_in <= $urandom_range(1,10);
    @(posedge fif.clock);
    fif.wr <= 1'b0;
    $display("[DRV] : DATA WRITE  data : %0d",fif.data_in);  
    @(posedge fif.clock);
  endtask
  
  task write_till_full();
    for(int i = 0; i < 16; i++)
    begin
    @(posedge fif.clock);
    fif.rst <= 1'b0;
    fif.rd <= 1'b0;
    fif.wr <= 1'b1;
    fif.data_in <= $urandom_range(1,10);
    @(posedge fif.clock);
    fif.wr <= 1'b0;
    $display("[DRV] : DATA WRITE  data : %0d",fif.data_in);  
    @(posedge fif.clock);
    wcount++;
    @(next); ////send next trans
    end
  endtask
  
  task main();
    write_till_full(); 
    read_till_empty();
    ->done;
  endtask
  
  
   task read();  
    @(posedge fif.clock);
    fif.rst <= 1'b0;
    fif.rd <= 1'b1;
    fif.wr <= 1'b0;
    @(posedge fif.clock);
    fif.rd <= 1'b0;      
    $display("[DRV] : DATA READ");  
    @(posedge fif.clock);
  endtask
  
  
   task read_till_empty();
    for(int i = 0; i < 16; i++)
    begin
    @(posedge fif.clock);
    fif.rst <= 1'b0;
    fif.rd <= 1'b1;
    fif.wr <= 1'b0;
    @(posedge fif.clock);
    fif.rd <= 1'b0;      
    $display("[DRV] : DATA READ");  
    @(posedge fif.clock);
    rcount++;
    @(next); 
    end
  endtask
  
  
  //////Applying RANDOM STIMULUS TO DUT
  task run();
    main();
  endtask
  
  
endclass

///////////////////////////////////////////////////////


class monitor;

   virtual fifo_if fif;
  
   mailbox #(transaction) mbx;
  
   transaction tr;
  

  
  

  
    function new(mailbox #(transaction) mbx);
      this.mbx = mbx;     
   endfunction;
  
  
  task run();
    tr = new();
    
    forever begin
      repeat(2) @(posedge fif.clock);
      tr.wr = fif.wr;
      tr.rd = fif.rd;
      tr.data_in = fif.data_in;
      tr.full = fif.full;
      tr.empty = fif.empty; 
      @(posedge fif.clock);
      tr.data_out = fif.data_out;
    
      mbx.put(tr);
      $display("[MON] : Wr:%0d rd:%0d din:%0d dout:%0d full:%0d empty:%0d",tr.wr, tr.rd, tr.data_in, tr.data_out, tr.full, tr.empty);
    end
    
  endtask
   
endclass

/////////////////////////////////////////////////////


class scoreboard;
  
   mailbox #(transaction) mbx;
  
   transaction tr;
  
   event next;
  
  bit [7:0] din[$];
  bit[7:0] temp;
  int err = 0;
  
   function new(mailbox #(transaction) mbx);
      this.mbx = mbx;     
    endfunction;
  
  
  task run();
    
  forever begin
    
    mbx.get(tr);
    
    $display("[SCO] : Wr:%0d rd:%0d din:%0d dout:%0d full:%0d empty:%0d",tr.wr, tr.rd, tr.data_in, tr.data_out, tr.full, tr.empty);
    
    if(tr.wr == 1'b1)
      begin 
        if(tr.full == 1'b0)
         begin
           din.push_front(tr.data_in);
           $display("[SCO] : DATA STORED IN QUEUE :%0d", tr.data_in);
         end
         else
         begin
           $display("[SCO] : FIFO is full");
         end
         $display("--------------------------------------"); 
      end
    
    if(tr.rd == 1'b1)
      begin
        if(tr.empty == 1'b0)
          begin  
           temp = din.pop_back();
          
          if(tr.data_out == temp)
            $display("[SCO] : DATA MATCH");
           else begin
             $error("[SCO] : DATA MISMATCH");
             err++;
           end
        end
        else 
          begin
            $display("[SCO] : FIFO IS EMPTY");
          end
        
        $display("--------------------------------------"); 
     end
    
    ->next;
  end
  endtask

  
endclass
//////////////////////////////////////////////////////



class environment;

    generator gen;
    driver drv;
  
    monitor mon;
    scoreboard sco;
  
  mailbox #(transaction) gdmbx; ///generator + Driver
    
  mailbox #(transaction) msmbx; ///Monitor + Scoreboard

  event nextgs;
 

  virtual fifo_if fif;
  
  
  function new(virtual fifo_if fif);
 
    
    
    gdmbx = new();
    gen = new(gdmbx);
    drv = new(gdmbx);
    
    
    
    
    msmbx = new();
    mon = new(msmbx);
    sco = new(msmbx);
    
    
    this.fif = fif;
    
    drv.fif = this.fif;
    mon.fif = this.fif;
    
    
    drv.next = nextgs;
    sco.next = nextgs;

  endfunction
  
  
  
  task pre_test();
    drv.reset();
  endtask
  
  task test();
  fork
   // gen.run();
    drv.run();
    mon.run();
    sco.run();
  join_any
    
  endtask
  
  task post_test();
    wait(drv.done.triggered);  
    $display("---------------------------------------------");
    $display("Error Count :%0d", sco.err);
    $display("---------------------------------------------");
    
    $finish();
  endtask
  
  task run();
    pre_test();
    test();
    post_test();
  endtask
  
  
  
endclass


///////////////////////////////////////////////////////

    

    
    fifo_if fif();
  fifo dut (fif.clock, fif.rst, fif.wr, fif.rd, fif.data_in, fif.data_out, fif.empty, fif.full);

    
    initial begin
      fif.clock <= 0;
    end
    
    always #10 fif.clock <= ~fif.clock;
    
    environment env;
    
    
    
    initial begin
      env = new(fif);
      env.gen.count = 10;
      env.run();
    end
      
    
    initial begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end
   
    
  endmodule


////////////////////////////////////////////////////////
