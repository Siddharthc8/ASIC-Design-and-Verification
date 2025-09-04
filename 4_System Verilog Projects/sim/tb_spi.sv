`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2024 08:30:47 PM
// Design Name: 
// Module Name: tb_spi
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
module tb_spi();

class transaction;
  
  rand bit newd;
  rand bit [11:0] din;
  bit cs;
  bit mosi;
  
  // Display function for debugging
  function void display (input string tag);
    $display("[%0s] : DATA_NEW : %0b DIN : %0d CS : %b MOSI : %0b ", tag, newd, din, cs, mosi);    
  endfunction
  
  // Transaction copy function
  function transaction copy();
    copy = new();
    copy.newd = this.newd;
    copy.din = this.din;
    copy.cs = this.cs;
    copy.mosi = this.mosi;
  endfunction
  
endclass
 
 
////////////////Generator Class
class generator;
  
  transaction tr;
  mailbox #(transaction) mbx;
  event done;
  int count = 0;
  event drvnext;
  event sconext;
  
  // Constructor
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
    tr = new();
  endfunction
  
  // Task to generate transactions
  task run();
    repeat(count) begin
      assert(tr.randomize) else $error("[GEN] :Randomization Failed");
      mbx.put(tr.copy);
      tr.display("GEN");
      @(drvnext);
      @(sconext);
    end
    -> done;
  endtask
  
endclass
 
////////////////Driver Class
 
class driver;
  
  virtual spi_if vif;
  transaction tr;
  mailbox #(transaction) mbx;
  mailbox #(bit [11:0]) mbxds;
  event drvnext;
  
  bit [11:0] din;
 
  // Constructor
  function new(mailbox #(bit [11:0]) mbxds, mailbox #(transaction) mbx);
    this.mbx = mbx;
    this.mbxds = mbxds;
  endfunction
  
  // Task to reset the driver
  task reset();
     vif.rst <= 1'b1;
     vif.cs <= 1'b1;
     vif.newd <= 1'b0;
     vif.din <= 1'b0;
     vif.mosi <= 1'b0;
    repeat(10) @(posedge vif.clk);
      vif.rst <= 1'b0;
    repeat(5) @(posedge vif.clk);
 
    $display("[DRV] : RESET DONE");
    $display("-----------------------------------------");
  endtask
  
  // Task to drive transactions
  task run();
    forever begin
      mbx.get(tr);
      @(posedge vif.sclk);
      vif.newd <= 1'b1;
      vif.din <= tr.din;
      mbxds.put(tr.din);
      @(posedge vif.sclk);
      vif.newd <= 1'b0;
      wait(vif.cs == 1'b1);
      $display("[DRV] : DATA SENT TO DAC : %0d",tr.din);
      ->drvnext;
    end
  endtask
  
endclass
 
////////////////Monitor Class
class monitor;
  transaction tr;
  mailbox #(bit [11:0]) mbx;
  bit [11:0] srx; // Received data
 
  virtual spi_if vif;
 
  // Constructor
  function new(mailbox #(bit [11:0]) mbx);
    this.mbx = mbx;
  endfunction
 
  // Task to monitor the bus
  task run();
    forever begin
      @(posedge vif.sclk);
      wait(vif.cs == 1'b0); // Start of transaction
      @(posedge vif.sclk);
 
      for (int i = 0; i <= 11; i++) begin
        @(posedge vif.sclk);
        srx[i] = vif.mosi;
      end
 
      wait(vif.cs == 1'b1); // End of transaction
 
      $display("[MON] : DATA SENT : %0d", srx);
      mbx.put(srx);
    end
  endtask
 
endclass
 
////////////////Scoreboard Class
 
class scoreboard;
  mailbox #(bit [11:0]) mbxds, mbxms;
  bit [11:0] ds; // Data from driver
  bit [11:0] ms; // Data from monitor
  event sconext;
 
  // Constructor
  function new(mailbox #(bit [11:0]) mbxds, mailbox #(bit [11:0]) mbxms);
    this.mbxds = mbxds;
    this.mbxms = mbxms;
  endfunction
 
  // Task to compare data from driver and monitor
  task run();
    forever begin
      mbxds.get(ds);
      mbxms.get(ms);
      $display("[SCO] : DRV : %0d MON : %0d", ds, ms);
 
      if (ds == ms)
        $display("[SCO] : DATA MATCHED");
      else
        $display("[SCO] : DATA MISMATCHED");
 
      $display("-----------------------------------------");
      ->sconext;
    end
  endtask
endclass
 
////////////////Environment Class
 
class environment;
 
    generator gen;
    driver drv;
    monitor mon;
    scoreboard sco;
 
    event nextgd; // gen -> drv
    event nextgs; // gen -> sco
 
    mailbox #(transaction) mbxgd; // gen - drv
    mailbox #(bit [11:0]) mbxds; // drv - mon
    mailbox #(bit [11:0]) mbxms; // mon - sco
 
    virtual spi_if vif;
 
  // Constructor
  function new(virtual spi_if vif);
    mbxgd = new();
    mbxms = new();
    mbxds = new();
    gen = new(mbxgd);
    drv = new(mbxds, mbxgd);
 
    mon = new(mbxms);
    sco = new(mbxds, mbxms);
 
    this.vif = vif;
    drv.vif = this.vif;
    mon.vif = this.vif;
 
    gen.sconext = nextgs;
    sco.sconext = nextgs;
 
    gen.drvnext = nextgd;
    drv.drvnext = nextgd;
  endfunction
 
  // Task to perform pre-test actions
  task pre_test();
    drv.reset();
  endtask
 
  // Task to run the test
  task test();
  fork
    gen.run();
    drv.run();
    mon.run();
    sco.run();
  join_any
  endtask
 
  // Task to perform post-test actions
  task post_test();
    wait(gen.done.triggered);
    $finish();
  endtask
 
  // Task to start the test environment
  task run();
    pre_test();
    test();
    post_test();
  endtask
endclass
 
////////////////Testbench Top

 
  spi_if vif();
  spi dut(vif.clk, vif.newd, vif.rst, vif.din, vif.sclk, vif.cs, vif.mosi);
 
  initial begin
    vif.clk <= 0;
  end
 
  always #10 vif.clk <= ~vif.clk;
 
  environment env;
 
  initial begin
    env = new(vif);
    env.gen.count = 20;
    env.run();
  end
 
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
