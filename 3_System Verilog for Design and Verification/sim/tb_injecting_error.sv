`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2024 12:50:19 AM
// Design Name: 
// Module Name: tb_injecting_error
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


module tb_injecting_error();

interface and_if;
    logic [3:0] a;
    logic [3:0] b;
    logic [4:0] sum;
    logic clk;
    
    // This shows that "a" and "b" will be driven out from the driver class
    modport DRV (output a,b, input sum,clk); // Just like a function where and b are exiting from Driver class

endinterface

//.....................................
class Transaction;
    
   randc bit [3:0] a;
   randc bit [3:0] b;
   bit [4:0] sum;
   
   function void display();
    $display(" a: %0d, b: %0d, sum: %0d", a, b, sum);  // y is output so not triggered
   endfunction
   
   virtual function Transaction copy();
       copy = new();
       copy.a = this.a;
       copy.b = this.b;
       copy.sum = this.sum;
   
   endfunction
   
endclass

//.....................................................
class Error extends Transaction;

    function Transaction copy();
       copy = new();
       copy.a = 0;
       copy.b = 0;
       copy.sum = this.sum;
       
   endfunction
   
//    constraint data_c { a==0; b==0; }
    
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
            $display("[GEN}  data->  [DRV]");
            trans.display();
            #20;
        end
        -> done;
    endtask   

endclass

//..........................................
class Driver;
    
    //  The interface MODPORT restriction is applies as .DRV in the next line
    virtual and_if .DRV aif;    // Calling an interface in a class doesn't require braces n the end
    
    Transaction trans_drv;
    mailbox #(Transaction) mbx;
    event next;
    
    function new (mailbox #(Transaction) mbx);
        this.mbx = mbx;
    endfunction
    
    task run();
        forever begin
            mbx.get(trans_drv);
            
            @(posedge aif.clk);
            aif.a <= trans_drv.a;
            aif.b <= trans_drv.b;
            
            $display("[DRV}  <-data  [GEN]");
            trans_drv.display();
//            -> next;
        end
    endtask

endclass 

    
//.....................................MAIN MODULE......................................//

//......CLOCK GENERATION AND INTERFACE DECLARATION...................//

    and_if aif();    // Braces needed at the end if calling in testbench top
    
    add dut (
        .a(aif.a),
        .b(aif.b),
        .sum(aif.sum),
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
    Error err;
    event done;
    
    initial begin
        mbx = new();     // Don't forget this part
        err = new();
        gen = new(mbx);
        drv = new(mbx);
        
        drv.aif = aif;  // Diver class interface = aif in tb top
        gen.done = done;
        gen.trans = err;   // Copying any similar data or 
        // Display command won't work here as run task in driver is a forever loo[p so only exits with $finish command
    end
    
    initial begin
        fork          // To execute them in parallel
            gen.run();
            drv.run();
        join_none           // Non-blocking so it does not wait for the completion of the fork methods
            wait(done.triggered);
            #20;
            $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;

    end

endmodule
