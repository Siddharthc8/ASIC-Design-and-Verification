`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2025 09:07:37 PM
// Design Name: 
// Module Name: tb_add_sv
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


module tb_add_sv();


    class transaction;
      
    randc bit [7:0] a;
    randc bit [7:0] b;
    bit [8:0] sum;
      
    endclass
     
    /////////////////////////////////////  
      
    class generator;
      
    mailbox mbx;
    event done;
    transaction t;
    integer i;
     
    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction
     
    task main();
        t = new();
        for(i = 0; i < 25; i++)
        begin
            t.randomize();
            mbx.put(t);
            $display("[GEN] : Data send to Driver a:%0d and b:%0d",t.a,t.b);
            @(done);
        end
    endtask
    endclass
     
    ///////////////////////////////////////////////////////
     
    class driver;
    mailbox mbx;
    transaction t;
    event done;
    virtual add_intf vif;
     
    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction
     
    task main();
    t = new();
    forever 
    begin
        mbx.get(t);
        vif.a <= t.a;
        vif.b <= t.b;
        $display("[DRV] : Interface triggered with a:%0d and b:%0d",t.a,t.b);
        repeat(2) @(posedge vif.clk);  
        -> done;
    end
    endtask
     
    endclass  
     
    ////////////////////////////////////////////////
    class monitor;
     virtual add_intf vif;
     mailbox mbx;
     transaction t;
     
     function new(mailbox mbx);
        this.mbx = mbx;
     endfunction
     
    task main();
    t = new();
    forever begin
        repeat(2) @(posedge vif.clk); 
        t.a = vif.a;
        t.b = vif.b;
        t.sum = vif.sum;
        mbx.put(t);
        $display("[MON] : Data send to Scoreboard a: %0d, b:%0d and sum:%0d ",vif.a, vif.b, vif.sum);
    end
      
    endtask
      
     
    endclass
     
    ////////////////////////////////////////////
      
    class scoreboard;
    mailbox mbx;
    transaction t;
    bit [8:0] temp;
     
    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction
     
    task main();
    t = new();
    forever 
    begin
        mbx.get(t);
        if(t.sum == t.a + t.b)
        $display("[SCO] :Test Passed");
        else
        $display("[SCO] :Test Failed");
    end
    endtask
    endclass
     
      //////////////////////////////////////////////////
    class environment;
    generator gen;
    driver drv;
    monitor mon;
    scoreboard sco;
     
    mailbox gdmbx, msmbx;
     
    virtual add_intf vif;
    event gddone;
     
    function new(mailbox gdmbx, mailbox msmbx);
        this.gdmbx = gdmbx;
        this.msmbx = msmbx;
        gen = new(gdmbx);
        drv = new(gdmbx);
        mon = new(msmbx);
        sco = new(msmbx);
    endfunction
     
    task main();
        drv.vif = vif;
        mon.vif = vif;
         
        gen.done = gddone;
        drv.done = gddone;
         
        fork
        gen.main();
        drv.main();
        mon.main();
        sco.main();
        join_any
     
    endtask
    endclass
     
    ////////////////////////////////////////////////////  
      
    environment e;
    mailbox gdmbx, msmbx;
     
    add_intf vif();
     
    add dut (vif.a, vif.b,vif.clk, vif.sum);
      
    bind add_sv add_sv_assert dut2 (vif.a, vif.b,vif.clk, vif.sum);
     
    initial 
    begin
        gdmbx = new();
        msmbx = new();
        e = new(gdmbx,msmbx);
        e.vif = vif;
        @(posedge vif.clk);  
        e.main();
    end
  
  initial begin
    vif.clk = 0;
  end
  
  always #5 vif.clk =~vif.clk;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #500;
    $finish;
  end
 
 
 
endmodule
