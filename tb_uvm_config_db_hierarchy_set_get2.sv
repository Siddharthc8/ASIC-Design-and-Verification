/* 

    UVM config_db precedence test: Sets same parameter from both test (value=100) and env (value=200) classes using null context. 
    
    Demonstrates 'last write wins' - agent retrieves 200 since env's build_phase executes after test's.

    Tests UVM config_db override: test sets 100, env sets 200, agent gets 200. Shows last-write-wins behavior."

*/



`include "uvm_macros.svh"
import uvm_pkg::*;

class my_agent extends uvm_agent;
  `uvm_component_utils(my_agent)
  
  int my_value;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(int)::get(this, "", "my_value", my_value))
      `uvm_fatal(get_type_name(), "Failed to get my_value from config_db")
    `uvm_info(get_type_name(), $sformatf("Got my_value = %0d", my_value), UVM_LOW)
  endfunction
endclass

class my_env extends uvm_env;
  `uvm_component_utils(my_env)
  
  my_agent agent;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Set from env class with null context (test_top scope)
    uvm_config_db#(int)::set(null, "uvm_test_top.env.agent", "my_value", 200);
    `uvm_info(get_type_name(), "Set my_value = 200 from ENV", UVM_LOW)
    
    agent = my_agent::type_id::create("agent", this);
  endfunction
endclass

class my_test extends uvm_test;
  `uvm_component_utils(my_test)
  
  my_env env;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Set from test class with null context (test_top scope)
    uvm_config_db#(int)::set(null, "uvm_test_top.env.agent", "my_value", 100);
    `uvm_info(get_type_name(), "Set my_value = 100 from TEST", UVM_LOW)
    
    env = my_env::type_id::create("env", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    #10;
    phase.drop_objection(this);
  endtask
endclass

module top;
  initial begin
    run_test("my_test");
  end
endmodule




// Output 

/*
    UVM_INFO @ 0: reporter [RNTST] Running test my_test...

    UVM_INFO testbench.sv(55) @ 0: uvm_test_top [my_test] Set my_value = 100 from TEST

    UVM_INFO testbench.sv(35) @ 0: uvm_test_top.env [my_env] Set my_value = 200 from ENV
    
    UVM_INFO testbench.sv(17) @ 0: uvm_test_top.env.agent [my_agent] Got my_value = 200
<<<<<<< HEAD
*/



=======
*/
>>>>>>> 4f9beed (Added nothing)
