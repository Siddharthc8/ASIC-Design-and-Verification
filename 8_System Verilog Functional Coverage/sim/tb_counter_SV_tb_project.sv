`timescale 1ns / 1ps


// NOTE :  Functional coverage in Monitor Class

 module tb_counter_SV_tb_project();

class transaction;
  
rand bit [7:0] loadin;
bit load;
bit rst;
bit up;  
bit [7:0] y;
  
endclass
 
 
////////////////////////
class generator;
  
  
transaction t;
mailbox mbx;
event done;
integer i;
 
  
function new(mailbox mbx);
this.mbx = mbx;
endfunction
 
  
task run();
t = new();
    for(i =0; i< 200; i++) begin
      t.randomize;
      mbx.put(t);
      $display("[GEN]: Data send to driver");
      @(done);
      end    
endtask
  
  
endclass
 
 
///////////////////////////////
class driver;
mailbox mbx;
transaction t;
event done;
 
virtual counter_8_intf vif;
 
function new(mailbox mbx);
this.mbx = mbx;
endfunction
 
 
task run();
t= new();
forever begin
mbx.get(t);
vif.loadin <= t.loadin;
$display("[DRV] : Trigger Interface");
@(posedge vif.clk);
  ->done; 
end
endtask
 
 
endclass
 
////////////////////////////////////////////
 
class monitor;
virtual counter_8_intf vif;
mailbox mbx;
transaction t;
  
 ///////////adding coverage
  
  ///ld  rst  loaddin dout
  
  covergroup c ;
    option.per_instance = 1;
    
    
      coverpoint t.loadin {         // ranges of laodin are checked
      bins lower = {[0:84]};     
      bins mid = {[85:169]};
      bins high = {[170:255]};   
    }
    
    
    
 
    coverpoint t.rst {      
      bins rst_low = {0};
      bins rst_high = {1};
    }
    
    coverpoint t.load {
      bins ld_low = {0};
      bins ld_high = {1};
    }
    
 
    
      coverpoint t.y {
      bins lower = {[0:84]};
      bins mid = {[85:169]};
      bins high = {[170:255]};
    }
    
    
    cross_ld_loadin : cross t.load, t.loadin             // Loadin is valid only when load is high 
    {
      ignore_bins unused_ld = binsof(t.load) intersect {0}; 
    }
    
     
     cross_rst_up : cross t.rst, t.up                    // Up and down when rst is low
    { 
      ignore_bins unused_rst = binsof(t.rst) intersect {1};
    }
 
    
    cross_rst_y : cross t.rst, t.y                      // The output y when rst is low
    {
      ignore_bins unused_rst = binsof(t.rst) intersect {1};
    }
 
  endgroup
  
   
  
  
 
function new(mailbox mbx);
this.mbx = mbx;
c = new();  
endfunction
  
  
 
task run();
t = new();
forever begin
t.loadin = vif.loadin;
t.y = vif.y;
t.rst = vif.rst;
t.up = vif.up;
t.load = vif.load;
  
c.sample();
  
mbx.put(t);
$display("[MON] : Data send to Scoreboard");
@(posedge vif.clk);
end
endtask
endclass  
 
///////////////////////////////////////////////////
 
class scoreboard;
mailbox mbx;
transaction t;
bit [7:0] temp; 
 
function new(mailbox mbx);
this.mbx = mbx;
endfunction
 
task run();
t = new();
forever begin
mbx.get(t);
end
endtask
endclass  
 
 
/////////////////////////////////////////////////
class environment;
generator gen;
driver drv;
monitor mon;
scoreboard sco;
 
virtual counter_8_intf vif;
 
mailbox gdmbx;
mailbox msmbx;
 
event gddone;
 
function new(mailbox gdmbx, mailbox msmbx);
this.gdmbx = gdmbx;
this.msmbx = msmbx;
 
gen = new(gdmbx);
drv = new(gdmbx);
 
mon = new(msmbx);
sco = new(msmbx);
endfunction
 
task run();
gen.done = gddone;
drv.done = gddone;
 
drv.vif = vif;
mon.vif = vif;
 
fork 
gen.run();
drv.run();
mon.run();
sco.run();
join_any
 
endtask
 
endclass
 
/////////////////////////////////////
 
 
environment env;
 
mailbox gdmbx;
mailbox msmbx;
 
counter_8_intf vif();
 
counter_8 dut ( vif.clk, vif.rst, vif.up, vif.load,  vif.loadin, vif.y );
 
always #5 vif.clk = ~vif.clk;
  
initial begin
 vif.clk = 0;
 vif.rst = 1;
 #50; 
 vif.rst = 0;  
end
 
initial begin
#60;
  repeat(20) begin
 vif.load = 1;
 #10;
  vif.load = 0;
 #100;
  end
end
  
 initial begin
#60;
  repeat(20) begin
  vif.up = 1;
 #70;
  vif.up = 0;
 #70;
  end
end 
 
initial begin
gdmbx = new();
msmbx = new();
env = new(gdmbx, msmbx);
env.vif = vif;
env.run();
#2000;
$finish;
end
  
initial begin
  $dumpfile("dump.vcd"); 
  $dumpvars;  
end
endmodule