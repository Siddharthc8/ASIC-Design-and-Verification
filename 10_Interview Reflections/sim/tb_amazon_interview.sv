`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2025 05:18:15 PM
// Design Name: 
// Module Name: tb_amazon_interview
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


module tb_amazon_interview();

/////////////////////////////////////////////////////////////// 

//                      Screening Round

///////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
// Q1) Tell me about yourself

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Q2) Explain I2C working

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Q3) Explain back pressure and clock stretching and checking scenarios

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Q4) Write an assertion to check -> Within 1:10 cycles grant should get asserted after req is asserted
    logic clk, grant, req, rst;
    
    // Within 1:10 cycles grant should get asserted after req is asserted
    assert property( @(posedge clk) disable iff (rst) $rose(req) |-> strong(##[1:10] $rose(grant))) else `uvm_error("ASSERT", "Assertion failed check logs");
    
    // Follow up : How to make sure req stays high until grant goes high          // XXXXXXXXXXXXXX   WRONG   XXXXXXXXXXXXX//
    assert property( @(posedge clk) disable iff (rst) $rose(req) |-> $stable(req) throughout ##[1:10] $rose(grant)) else `uvm_error("ASSERT", "Assertion failed check logs"); 
    // This will not work as -> P throughout Q means P must hold during every cycle when Q holds - but Q must be a sequence that describes a time range or event pattern, not a delay operator.
    
    assert property (@(posedge clk) disable iff (rst) req |-> (req && !grant)[*0:9] ##1 grant) else `uvm_error("ASSERT", "Assertion failed check logs"); 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Q5) What is the differnece between UVM_TLM_FIFO and UVM_ANALYSIS_FIFO

/* Ans) * Class: uvm_tlm_fifo #(T)
        * Type: UVM TLM (Transaction-Level Modeling) FIFO
        * Point-to-point communication   --->   Producer to Consumer
        * Supports blocking and non-blocking read/write (e.g., get, peek, try_get, put, etc.) 
        * Transactions are removed once read.    
        * Use Case: When you want direct, synchronized communication between two components (e.g., driver and monitor, or sequencer and driver).  
        
        * Type: UVM Analysis FIFO (subscriber)
        * Class: uvm_analysis_fifo #(T)
        * Works with uvm_analysis_port / uvm_analysis_imp
        * Transactions are broadcast to all connected subscribers.  -->   One Host to Many Subscribers
        * Does not support blocking reads; it receives data using write(T t) and stores it in the FIFO.
        * Supports pull-type access (e.g., get, peek) after the transaction has been pushed via analysis.
        * Use Case: When you want to monitor, log, or analyze transactions without affecting the main data flow (e.g., scoreboard, coverage collection).
*/

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Q6)  Write a monitor code for the following and the block diagram is pasted in the chat

//  * Everything is driven on Posedge of clock, Valid signal is qualifier for all rest of the signals
//  * SOP is start of packet, when new packet starts SOP stays high for one clock cycle
//  * EOP is end of packet, When packet ends EOP stays high for one clock
//  * pkt_len indicates packet length in no. of bytes. and it is valid at SOP only. For example, pkt_length = 37, total packet size is 37 bytes
//  * Data is valid from SOP to EOP including them. There can be idle cycles in between.
    

class transaction extends uvm_sequence_item();
`uvm_object_utils(transaction)
    
    logic [31:0] data[];
function new(input string path = "transaction");
    super.new(path);
endfunction
endclass


class monitor extends uvm_monitor;
`uvm_component_utils(monitor)
    
    transaction tr;
    amazon_if vif;
    int i = 0;
            
    function new(input string path = "monitor", uvm_component parent = null);
        super.new(path, parent);
    endfunction
    
//  * Everything is driven on Posedge of clock, Valid signal is qualifier for all rest of the signals
//  * SOP is start of packet, when new packet starts SOP stays high for one clock cycle
//  * EOP is end of packet, When packet ends EOP stays high for one clock
//  * pkt_len indicates packet length in no. of bytes. and it is valid at SOP only. For example, pkt_length = 37, total packet size is 37 bytes
//  * Data is valid from SOP to EOP including them. There can be idle cycles in between.
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
        
            @(posedge vif.clk);
            tr = transaction::type_id::create("tr");
            
            // We are waiting for valid and SOP to become high
            wait(vif.SOP && vif.valid);
            tr.pkt_len = vif.pkt_len;          // Sample the packet length 
            tr.data = new[tr.pkt_len];         // set the data size array to eb of the incoming data size
            i = 0;                             
            
            // as long as it is not EOP we can sample based on valid
            while(!vif.eop) begin         // Suggestion is that do not iterate over pkt_len as it may contain error so use vif.eop
            
                if(vif.valid) begin
                    tr.data[i++] = vif.data;
                    @(posedge vif.clk);
                end
            end
            
            if(vif.eop) begin
                if(vif.valid) begin       // This "if" statement is my own
                    tr.data[i++] = vif.data;
                    @(posedge vif.clk);
                end
            end
            
            send.write(tr);
        end
        
    endtask 
    
///////////////////////////////////////////
    // My version and is good actually
    ///////////////////////////////////////////////////
    task run_phase1(uvm_phase phase);
    super.run_phase1(phase);
    
    forever begin
        
        @(posedge vif.clk);
        tr = transaction::type_id::create("tr");
        
        wait(vif.sop && vif.valid);
        tr.pkt_len = vif.pkt_len;
        tr.data = new[tr.pkt_len];
        i = 0;
        
        tr.data[i++] = vif.data;            // Sample data at SOP
        
        while (1) begin        // Suggestion is that do not iterate over pkt_len as it may contain error
            @(posedge vif.clk);
            
            if(!vif.valid) begin     // Actually not needed 
                continue;
            end
            else if(vif.valid && !vif.eop) begin
                tr.data[i++] = vif.data;
            end
            else if(vif.valid && vif.eop) begin
                tr.data[i++] = vif.data;      // Sample data at SOP
                // Can use <  but != checks for both more packets and less packets
                if(i != tr.pkt_len) 
                    `uvm_error("MON", $sformatf("EOP is at bit %0d, actual pkt_len %0d", i, tr.pkt_len)); 
                break;
            end
        end
    end
    
    endtask
    
endclass

// Q7) Write a constraint to make sure every even item in an array is even and every odd item is odd.
class transaction1 extends uvm_sequence_item();
`uvm_object_utils(transaction1)
    
    function new(input string path = "transaction1");
        super.new(path);
    endfunction

    int arr[10];
    
    constraint even_odd { 
    foreach(arr[i]) 
        if( i % 2 == 0 ) arr[i] % 2 == 0;
        else arr[i] % 2 != 0;
    
    }
    
endclass

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////// 

//                      CODING ROUND 1

///////////////////////////////////////////////////////////////

// Q8) Write a driver code for the following 

// Write a UVM driver for valid-ready protocol
//  Implement valid-ready handshake protocol where:
//    - Transaction happens when valid && ready are both high
//    - Valid must remain stable until ready is asserted
//    - Data must remain stable when valid is high

// For reference, assume the following interface:
interface my_interface(input logic clk, rst_n);
    logic        valid;
    logic        ready;
    logic [31:0] data;
    // Add any other signals you need
endinterface

// For reference, assume the following transaction:
class my_transaction extends uvm_sequence_item;
    rand bit [31:0] data;
    // Add any other fields you need
endclass


//--------------------------------------------------------------------------
// Driver: my_driver
//--------------------------------------------------------------------------
class my_driver extends uvm_driver #(my_transaction);

  // Factory registration
  `uvm_component_utils(my_driver)

  // Virtual interface handle
  virtual my_interface vif;
  transaction tr;

  // Constructor
  function new (string name = "my_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // -----------------------------------------------------------------------
  // build_phase - grab the virtual interface from the config DB
  // -----------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
    if ( !uvm_config_db#(virtual my_interface)::get(this, "", "vif", vif) )
      `uvm_fatal("NOVIF", "Virtual interface must be set for my_driver")
  endfunction

  // -----------------------------------------------------------------------
  // reset_phase - drive all outputs inactive during reset
  // -----------------------------------------------------------------------
  task reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    vif.valid <= 1'b0;
    vif.data  <= '0;
    // Hold these values as long as reset is asserted
    @(negedge vif.rst_n);
  endtask

  // -----------------------------------------------------------------------
  // run_phase - main stimulus loop
  //  • Keep data & valid stable while waiting for ready
  //  • Drop valid one cycle after handshake completes
  // -----------------------------------------------------------------------
    virtual task run_phase(uvm_phase phase);
    
        // Wait until reset is released
        @(posedge vif.rst_n);            // When reset_n goes high ie for active high reset
            
        forever begin
            
            seq_item_port.get_next_item(tr);
                    
            vif.valid <= 1'b1;
            vif.data <= tr.data;
            
            do @(posedge vif.ready); while (!vif.ready);
            
            vif.valid <= 1'b0;         // Deassert after you see ready
            vif.data <= '0;
            
            @(posedge vif.clk);
            
            seq_item_port.item_done();
            
        end
    
    endtask
  
  endclass


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Q9) Write a code for Circular buffer push pop - Practice for full design as well

    logic [7:0] circ_buff [8];
    int tail = 0;
    int head = 0;
    int count = 0;
    logic [7:0] data = 0;  
    
    task push();
        if(count < 8) begin
            circ_buff[head] = data;
            count++;
            head = (head + 1) % 8;
        end
        else $display("ERROR: FIFO is full");
    endtask
    
    task pop();
        if(count > 0) begin
            data = circ_buff[tail];
            count--;
            tail = (tail +  1) % 8;
        end
        else $display("ERROR: FIFO is empty");
    endtask



////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////// 

//                      CODING ROUND 2

///////////////////////////////////////////////////////////////

// Q10) Write constraint to generate dynamic array with size of 100 to 200, values should be all even

class first_class;
    
    rand int array[];               // Don't forget the rand
    
    constraint ranger {
        soft array.size() inside {[100:200]};        // Ranged it within 100 to 200
        foreach(array[i]) array[i] % 2 == 0;    // All values even
     }

endclass

// FOLLOW UP :: Override the size to be something to be in the range of 1000 to 2000

initial begin
    
    first_class fc = new();
    fc.randomize() with { fc.array.size() inside {[1000:2000]}; };  // In order for this to work use "soft" keyword
    $display("Size - %d \n %p", fc.array.size(), fc.array); 
end


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Q11) // Two Drivers trying to access one interface
        // Control the access to only one driver accesses the interface
        // Using semaphore is an option 


class driver extends uvm_driver;
`uvm_component_utils(driver)

    function new(input string path = "", uvm_component parent);
        super.new(path, parent);
    endfunction
    
    semaphore sem;           // Since no objects is created or keys are assigned it should be connected from agent or env with a semaphore with key(s)
    
    virtual task run_phase(uvm_phase phase);
        
        forever begin
            seq_item_port.get_next_item(tr);
            sem.get(1);                       //---------->>  Getting semaphore access 
            //                       //
            //Drive logic to interface
            //                       // 
            sem.put(1);                       //---------->>  Releasing semaphore access
            seq_item_port.finish_item();
        
        end
        
    endtask

endclass
    
class agent extends uvm_agent;
`uvm_component_utils(agent)    
    
    driver drv1;
    driver drv2;
    
    function new(input string path = "", uvm_component parent);
        super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv1 = driver::type_id::create("drv1", this);           // Create an object for both the drivers
        drv2 = driver::type_id::create("drv2", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv1.seq_item_port.connect(seqr.seq_item_export);       // Connect the seq_item_port to exports of sequencer
        drv2.seq_item_port.connect(seqr.seq_item_export);
    endfunction

endclass


class env extends uvm_env;
`uvm_component_utils(env) 
    
    agent agt;
    semaphore sem;
    
    function new(input string path = "", uvm_component parent);
        super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = agent::type_id::create("agt", this);  
        sem = new(1);                              // Creating a semaphore with 1 key(s)
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.drv1.sem = sem;       // Connect the semaphores but only env class should have keys
        agt.drv2.sem = sem;      
    endfunction

endclass


endmodule










