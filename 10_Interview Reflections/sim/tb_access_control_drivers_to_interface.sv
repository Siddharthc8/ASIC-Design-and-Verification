`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/17/2025 11:32:01 AM
// Design Name: 
// Module Name: tb_access_control_drivers_to_interface
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


module tb_access_control_drivers_to_interface();

// Here to control multiple driver access to the interface by the drivers we use static semaphore

// So the technique used here is that we have are creating a "STATIC" varaible of semaphore inside the driver, creating object with 1 key
// But it is static so only one key across classes but wont work with different kind of classes of driver as only the driver class has this static object

class bus_transaction extends uvm_sequence_item;
  rand bit [31:0] addr;
  rand bit [31:0] data;
  rand bit        wr_rd; // 1=write, 0=read
  bit             driver_id; // 0=driver1, 1=driver2
  
  `uvm_object_utils_begin(bus_transaction)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(wr_rd, UVM_ALL_ON)
    `uvm_field_int(driver_id, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "bus_transaction");
    super.new(name);
  endfunction
endclass




// Sequence for driver1
class driver1_seq extends uvm_sequence #(bus_transaction);
  `uvm_object_utils(driver1_seq)
  
  task body();
    bus_transaction tx;
    repeat(5) begin
      tx = bus_transaction::type_id::create("tx");
      assert(tx.randomize() with {
        addr inside {[0:99]};
        wr_rd == 1;
      });
      `uvm_info("SEQ1", $sformatf("Generated transaction: %s", tx.convert2string()), UVM_MEDIUM)
      start_item(tx);
      finish_item(tx);
      #10;
    end
  endtask
endclass



// Sequence for driver2
class driver2_seq extends uvm_sequence #(bus_transaction);
  `uvm_object_utils(driver2_seq)
  
  task body();
    bus_transaction tx;
    repeat(5) begin
      tx = bus_transaction::type_id::create("tx");
      assert(tx.randomize() with {
        addr inside {[100:199]};
        wr_rd == 0;
      });
      `uvm_info("SEQ2", $sformatf("Generated transaction: %s", tx.convert2string()), UVM_MEDIUM)
      start_item(tx);
      finish_item(tx);
      #15;
    end
  endtask
endclass




class bus_driver extends uvm_driver #(bus_transaction);
  `uvm_component_utils(bus_driver)
  
  virtual bus_if vif;
  bit driver_id; // 0 for driver1, 1 for driver2
  static semaphore bus_lock = new(1); // Shared across all instances
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      
      // Acquire bus access
      bus_lock.get(1);
      `uvm_info("DRIVER", $sformatf("Driver %0d acquired bus access", driver_id), UVM_MEDIUM)
      
      // Drive transaction
      req.driver_id = this.driver_id;
      drive_transaction(req);
      
      // Release bus access
      bus_lock.put(1);
      `uvm_info("DRIVER", $sformatf("Driver %0d released bus access", driver_id), UVM_MEDIUM)
      
      seq_item_port.item_done();
    end
  endtask
  
  task drive_transaction(bus_transaction tx);
    vif.addr  <= tx.addr;
    vif.data  <= tx.data;
    vif.wr_rd <= tx.wr_rd;
    vif.valid <= 1'b1;
    
    @(posedge vif.clk);
    while(!vif.ready) @(posedge vif.clk);
    vif.valid <= 1'b0;
    
    `uvm_info("DRIVER", $sformatf("Driver %0d completed transaction: %s", 
             driver_id, tx.convert2string()), UVM_HIGH)
  endtask
endclass




class bus_agent extends uvm_agent;
  `uvm_component_utils(bus_agent)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  bus_driver driver1;
  bus_driver driver2;
  uvm_sequencer #(bus_transaction) sqr1, sqr2;
  
  function void build_phase(uvm_phase phase);
    // Create drivers and sequencers
    driver1 = bus_driver::type_id::create("driver1", this);
    driver2 = bus_driver::type_id::create("driver2", this);
    sqr1 = uvm_sequencer#(bus_transaction)::type_id::create("sqr1", this);
    sqr2 = uvm_sequencer#(bus_transaction)::type_id::create("sqr2", this);
    
    // Set driver IDs
    driver1.driver_id = 0;
    driver2.driver_id = 1;
    
    // Get virtual interface from config db
    if(!uvm_config_db#(virtual bus_if)::get(this, "", "vif", driver1.vif))
      `uvm_fatal("NO_VIF", "Virtual interface not found for driver1")
    driver2.vif = driver1.vif; // Both drivers share the same interface
  endfunction
  
  function void connect_phase(uvm_phase phase);
    // Connect sequencers to drivers
    driver1.seq_item_port.connect(sqr1.seq_item_export);
    driver2.seq_item_port.connect(sqr2.seq_item_export);
  endfunction
endclass


class bus_env extends uvm_env;
  `uvm_component_utils(bus_env)
  
  bus_agent agent;
  
  function void build_phase(uvm_phase phase);
    agent = bus_agent::type_id::create("agent", this);
  endfunction
endclass



class multi_driver_test extends uvm_test;
  `uvm_component_utils(multi_driver_test)
  
  bus_env env;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    env = bus_env::type_id::create("env", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    driver1_seq seq1;
    driver2_seq seq2;
    
    phase.raise_objection(this);
    
    seq1 = driver1_seq::type_id::create("seq1");
    seq2 = driver2_seq::type_id::create("seq2");
    
    fork
      seq1.start(env.agent.sqr1);
      seq2.start(env.agent.sqr2);
    join
    
    phase.drop_objection(this);
  endtask
endclass



endmodule
