`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2024 06:56:31 PM
// Design Name: 
// Module Name: tb_a71
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


module tb_a71();

//.................................................
interface add_if;
    logic [3:0] a;
    logic [3:0] b;
    logic [4:0] res;
    logic clk;
    
    // This shows that "a" and "b" will be driven out from the driver class
    modport DRV (output a,b, input res,clk); // Just like a function where and b are exiting from Driver class

endinterface

//.....................................
class Transaction;
    
   randc bit [3:0] a;
   randc bit [3:0] b;
   bit [4:0] res;
   
   function void display();
    $display(" a: %0d, b: %0d, res: %0d", a, b, res);  // y is output so not triggered
   endfunction
   
   function Transaction copy();
       copy = new();
       copy.a = this.a;
       copy.b = this.b;
       copy.res = this.res;
   
   endfunction
   
endclass

//...........................................
class Generator;
    
    Transaction trans;
    mailbox #(Transaction) mbx;
    event done; 
      
    function new (mailbox #(Transaction) mbx);
        this.mbx = mbx;
        trans = new();
    endfunction
    
    task run();
        
        for(int i=0; i<20; i++) begin

            assert(trans.randomize()) else $display("Randomization Failed");
            mbx.put(trans.copy());    // Sending the copy so randc can cycle within the range
            $display("\n[GEN}  data->  [DRV]");
            trans.display();
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
    event next;
    
    function new (mailbox #(Transaction) mbx);
        this.mbx = mbx;
    endfunction
    
    task run();
        forever begin
            mbx.get(trans_drv);
            $display("[DRV}  <-data  [GEN]");
            
            @(posedge aif.clk);
            aif.a <= trans_drv.a;
            aif.b <= trans_drv.b;
            
            trans_drv.display();
            -> next;
        end
    endtask

endclass 

    
//.....................................MAIN MODULE......................................//

//......CLOCK GENERATION AND INTERFACE DECLARATION...................//

    add_if aif();    // Braces needed at the end if calling in testbench top
    
    multiplier_nbit dut (
        .a(aif.a),
        .b(aif.b),
        .res(aif.res),
        .clk(aif.clk)
        );
    
    localparam T = 20;  // Clock Period
    initial begin
        aif.clk <= 0;
    end
    
    always #(T/2) aif.clk <= ~aif.clk;

//......................................
    Generator gen;
    mailbox #(Transaction) mbx;
    Driver drv;
    event done;
    
    initial begin
        mbx = new();     // Don't forget this part
        gen = new(mbx);
        drv = new(mbx);
        
        drv.aif = aif;  // Diver class interface = aif in tb top
        done = gen.done;
        // Display command won't work here as run task in driver is a forever loo[p so only exits with $finish command
    end
    
    initial begin
        fork          // To execute them in parallel
            gen.run();
            drv.run();
        join_none           // Non-blocking so it does not wait for the completion of the fork methods
            wait(done.triggered);
            $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;

    end

endmodule
