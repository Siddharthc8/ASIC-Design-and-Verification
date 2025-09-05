//Here’s what’s going on, and a tiny UVM testbench you can paste into EDA Playground to see it yourself.
//
//# What the two snippets are really doing
//
//`uvm_config_db::set(cntxt, inst_name, field, value)` stores a setting in the **UVM resource database** with two key pieces of information:
//
//1. **Scope (where it’s stored)**
//
//   * If `cntxt` is **non-null** (e.g. `this`), the entry is stored under that component’s scope (relative to that component).
//   * If `cntxt` is **null**, the entry is stored under the **root/global scope** and `inst_name` is treated like an absolute path from `uvm_test_top`.
//
//2. **Which instances it applies to**
//
//   * `inst_name` is a path (may include wildcards) that must match the receiver component’s full name.
//
//`uvm_config_db::get(this, "", "int_value", val)` searches **from the receiver upward**, scope by scope:
//
//* Driver scope → Agent scope → Env scope → Test scope → Root.
//* In the **first scope where at least one matching entry exists**, the **last value set in that scope** wins. (More distant scopes are not consulted once a match is found.)
//
//Now apply those rules:
//
//### CODE A
//
//* **In test:** `set(this,"env.mem_agnt.driver",...)` → entries stored in the **test scope**.
//* **In env:** `set(this,"mem_agnt.driver",...)` → entries stored in the **env scope**.
//
//When the **driver** calls `get`, it searches up: driver → agent → **env** (finds entries here) and **stops**. Inside the env scope, the **last set** (value `2`) wins. The test-scope values (`3`, `4`) are *ignored* because a nearer scope (env) already satisfied the request.
//
//### CODE B
//
//* All four sets use `cntxt=null` with an absolute path. That stores **all entries in the root scope**.
//* The driver’s `get` finds nothing until it reaches **root**, where it chooses the **last set overall** (due to being all in the same scope). Given normal build ordering (test sets first, then env sets), the last write is `2`, so the driver again gets `2`.
//
//**Key takeaways**
//
//* **Nearest matching scope wins; within that scope, last write wins.**
//* Using `this` (non-null) ties a setting to that component’s scope (good for local, reusable configuration).
//* Using `null` with an absolute path dumps everything into the root scope (useful for global overrides, but easier to accidentally override later in time).
//
//---
//
//# Minimal runnable reproduction (EDA Playground ready)
//
//Paste this single file into **EDA Playground** (choose a SystemVerilog + UVM 1.2 template), and run with:
//
//* `+UVM_TESTNAME=test_code_a`  → models **CODE A**
//* `+UVM_TESTNAME=test_code_b`  → models **CODE B**
//
//You should see the driver report `int_value=2` in both cases.
//
//```systemverilog


// testbench.sv
`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

// ---------------------------- Driver ----------------------------
class my_driver extends uvm_component;
  `uvm_component_utils(my_driver)
  int a_check;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(int)::get(this, "", "int_value", a_check)) begin
      `uvm_fatal("NO_VIF",
        $sformatf("int_value must be set for %s", get_full_name()))
    end
    else begin
      `uvm_info("DRV",
        $sformatf("Got int_value=%0d", a_check), UVM_LOW)
    end
  endfunction
endclass

// ---------------------------- Agent ----------------------------
class my_agent extends uvm_component;
  `uvm_component_utils(my_agent)
  my_driver driver;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = my_driver::type_id::create("driver", this);
  endfunction
endclass

// ---------------------------- Env A (CODE A behavior) ----------------------------
class env_a extends uvm_env;
  `uvm_component_utils(env_a)
  my_agent mem_agnt;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Store in ENV scope (relative to 'this')
    uvm_config_db#(int)::set(this, "mem_agnt.driver", "int_value", 1);
    uvm_config_db#(int)::set(this, "mem_agnt.driver", "int_value", 2);
    `uvm_info("ENV_A", "Set int_value=1 then 2 in ENV scope", UVM_LOW)

    mem_agnt = my_agent::type_id::create("mem_agnt", this);
  endfunction
endclass

// ---------------------------- Env B (CODE B behavior) ----------------------------
class env_b extends uvm_env;
  `uvm_component_utils(env_b)
  my_agent mem_agnt;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Store in ROOT scope (absolute path)
    uvm_config_db#(int)::set(null, "uvm_test_top.env.mem_agnt.driver", "int_value", 1);
    uvm_config_db#(int)::set(null, "uvm_test_top.env.mem_agnt.driver", "int_value", 2);
    `uvm_info("ENV_B", "Set int_value=1 then 2 in ROOT scope", UVM_LOW)

    mem_agnt = my_agent::type_id::create("mem_agnt", this);
  endfunction
endclass

// ---------------------------- Test A (CODE A behavior) ----------------------------
class test_code_a extends uvm_test;
  `uvm_component_utils(test_code_a)
  env_a env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Store in TEST scope (relative to 'this')
    uvm_config_db#(int)::set(this, "env.mem_agnt.driver", "int_value", 3);
    uvm_config_db#(int)::set(this, "env.mem_agnt.driver", "int_value", 4);
    `uvm_info("TEST_A", "Set int_value=3 then 4 in TEST scope", UVM_LOW)

    env = env_a::type_id::create("env", this);
  endfunction
endclass

// ---------------------------- Test B (CODE B behavior) ----------------------------
class test_code_b extends uvm_test;
  `uvm_component_utils(test_code_b)
  env_b env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Store in ROOT scope (absolute path)
    uvm_config_db#(int)::set(null, "uvm_test_top.env.mem_agnt.driver", "int_value", 3);
    uvm_config_db#(int)::set(null, "uvm_test_top.env.mem_agnt.driver", "int_value", 4);
    `uvm_info("TEST_B", "Set int_value=3 then 4 in ROOT scope", UVM_LOW)

    env = env_b::type_id::create("env", this);
  endfunction
endclass

// ---------------------------- Top ----------------------------
module top;
  initial begin
    run_test("test_code_a"); // select with +UVM_TESTNAME=test_code_a or test_code_b
  end
endmodule
```

//### What you should see
//
//* For **both** `test_code_a` and `test_code_b`, the driver prints:
//
//```
//UVM_INFO ... [DRV] Got int_value=2
//```
//
//### Want to observe a difference?
//
//Move one of the `set(null, ...)` calls in **Test B** to a *later* phase (e.g., `start_of_simulation_phase`) **and** move the driver’s `get` to that same or a later phase.
//Because CODE B stores everything in the **root** scope, the **last** write (in time) at root will win. In CODE A, the env-scope entry would still dominate because the search stops at the nearer scope even if the test writes later.
