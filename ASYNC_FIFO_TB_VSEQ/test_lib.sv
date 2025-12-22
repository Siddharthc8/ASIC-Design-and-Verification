class async_fifo_base_test extends uvm_test;
`uvm_component_utils(async_fifo_base_test)

async_fifo_env env;

`NEW_COMP

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
    env = async_fifo_env::type_id::create("env", this);
endfunction

function void end_of_elaboration_phase(uvm_phase phase);
super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
endfunction


function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    if(async_fifo_common::num_mismatches > 0 || async_fifo_common::num_matches == 0) begin
        `uvm_error("STATUS", $sformatf("TEST FAIL, num_matches = %0d, num_mismatches = %0d", async_fifo_common::num_matches, async_fifo_common::num_mismatches) );
    end  
    else begin
        // `uvm_info("STATUS", "TEST PASS" UVM_NONE);
        `uvm_info("STATUS", $sformatf("TEST PASS, num_matches = %0d, num_mismatches = %0d", async_fifo_common::num_matches, async_fifo_common::num_mismatches), UVM_NONE );
    end

    // Extra from claude to print coverage in EDA
    `uvm_info(get_type_name(), 
              "\n========================================\n COVERAGE SUMMARY\n========================================", 
              UVM_LOW)
    
endfunction

endclass


class fifo_wr_rd_test extends async_fifo_base_test;
`uvm_component_utils(fifo_wr_rd_test)

    `NEW_COMP
  
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      
      uvm_config_db#(int)::set(this, "*", "WRITE_COUNT", `DEPTH);
      uvm_config_db#(int)::set(this, "*", "READ_COUNT", `DEPTH);
      $display("Value of wr and rd count %d, %d", `DEPTH, `DEPTH);
      `uvm_info(get_type_name(), $sformatf("Scope %s", get_full_name()), UVM_MEDIUM);
      
    endfunction

    task run_phase(uvm_phase phase);
        write_seq write_seq_i;
        read_seq read_seq_i;
        write_seq_i = write_seq::type_id::create("write_seq_i");
        read_seq_i = read_seq::type_id::create("read_seq_i");

        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 100);
            write_seq_i.start(env.write_agent_i.sqr);
            read_seq_i.start(env.read_agent_i.sqr);
        phase.drop_objection(this);
    endtask

endclass


class fifo_write_error_test extends fifo_wr_rd_test;
`uvm_component_utils(fifo_write_error_test)

    `NEW_COMP
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      
      uvm_config_db#(int)::set(this, "*", "WRITE_COUNT", `DEPTH+1);    // Count value is DEPTH + 1 to raise full flag
      uvm_config_db#(int)::set(this, "*", "READ_COUNT", 0);        // We do not need read seq so we can set the count value to be zero
      $display("Value of wr and rd count %d, %d", `DEPTH+1, 0);  
      `uvm_info(get_type_name(), $sformatf("Scope %s", get_full_name()), UVM_MEDIUM);
      
    endfunction

    // No run_phase we shall extend it from wr_rd test
    // To turn off the write/read seq we can set their respective count value to 0 in config_db

endclass


class fifo_read_error_test extends fifo_wr_rd_test;
`uvm_component_utils(fifo_read_error_test)

    `NEW_COMP
    
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      
      uvm_config_db#(int)::set(this, "*", "WRITE_COUNT", `DEPTH);
      uvm_config_db#(int)::set(this, "*", "READ_COUNT", `DEPTH+1);  // Count value is DEPTH + 1 to raise empty flag and reading one after empty flag
      $display("Value of wr and rd count %d, %d", `DEPTH, `DEPTH+1);
      
    endfunction

endclass


class concurrent_write_read_test extends fifo_wr_rd_test;
`uvm_component_utils(concurrent_write_read_test)

    `NEW_COMP
  
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      
      uvm_config_db#(int)::set(this, "*", "WRITE_COUNT", 100);
      uvm_config_db#(int)::set(this, "*", "READ_COUNT", 100);
      $display("Value of wr and rd count %d, %d", 100, 100);
      `uvm_info(get_type_name(), $sformatf("Scope %s", get_full_name()), UVM_MEDIUM);
      
    endfunction

    task run_phase(uvm_phase phase);               // Do not use super as we do not want the previous seqeunce to run
        write_delay_seq write_seq_i;
        read_delay_seq read_seq_i;
        write_seq_i = write_delay_seq::type_id::create("write_seq_i");
        read_seq_i = read_delay_seq::type_id::create("read_seq_i");

        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 100);
        fork
            write_seq_i.start(env.write_agent_i.sqr);
            read_seq_i.start(env.read_agent_i.sqr);
        join
        phase.drop_objection(this);
    endtask

endclass


class top_wr_rd_top_sqr_test extends async_fifo_base_test;
`uvm_component_utils(top_wr_rd_top_sqr_test)

    `NEW_COMP

    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      
      uvm_config_db#(int)::set(this, "*", "WRITE_COUNT", `DEPTH);
      uvm_config_db#(int)::set(this, "*", "READ_COUNT", `DEPTH);
      $display("Value of wr and rd count %d, %d", `DEPTH, `DEPTH);
      `uvm_info(get_type_name(), $sformatf("Scope %s", get_full_name()), UVM_MEDIUM);
      
    endfunction

    task run_phase(uvm_phase phase);
        wr_rd_top_seq top_seq;
        top_seq = wr_rd_top_seq::type_id::create("top_seq");

        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 100);
            top_seq.start(env.top_sqr_i);           // Run the top_seq on the top_sqr
        phase.drop_objection(this);
    endtask



endclass


class concurrent_wr_rd_top_sqr_test extends async_fifo_base_test;
`uvm_component_utils( concurrent_wr_rd_top_sqr_test)

    `NEW_COMP

    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      
      uvm_config_db#(int)::set(this, "*", "WRITE_COUNT", `DEPTH);
      uvm_config_db#(int)::set(this, "*", "READ_COUNT", `DEPTH);
      $display("Value of wr and rd count %d, %d", `DEPTH, `DEPTH);
      `uvm_info(get_type_name(), $sformatf("Scope %s", get_full_name()), UVM_MEDIUM);
      
    endfunction

    task run_phase(uvm_phase phase);
        concurrent_wr_rd_top_seq top_seq;
        top_seq = concurrent_wr_rd_top_seq::type_id::create("top_seq");

        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 100);
            top_seq.start(env.top_sqr_i);           // Run the top_seq on the top_sqr
        phase.drop_objection(this);
    endtask



endclass