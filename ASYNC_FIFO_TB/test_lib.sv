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

endclass


class fifo_wr_rd_test extends async_fifo_base_test;
`uvm_component_utils(fifo_wr_rd_test)

    `NEW_COMP

// The following commented out method can be used or seqs can be instantiated and created in run_phase
/*
    write_seq write_seq_i;
    read_seq read_seq_i;

    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
        write_seq_i = write_seq::type_id::create("write_seq_i");
        read_seq_i = read_seq::type_id::create("read_seq_i");
    endfunction
*/
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
        uvm_config_db#(int)::set(this, "*", "WRITE_COUNT", `DEPTH)
            // `uvm_error(get_type_name(), "WRITE_COUNT not set");
        uvm_config_db#(int)::set(this, "*", "READ_COUNT", `DEPTH) 
            // `uvm_error(get_type_name(), "READ_COUNT not set");
        `uvm_info(get_type_name(), $sformat("Scope %s", this), UVM_MEDIUM);
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
        uvm_config_db#(int)::set(this, "*", "WRITE_COUNT", `DEPTH+1)    // Count value is DEPTH + 1 to raise full flag
            // $error(get_type_name(), "WRITE_COUNT not set");
        uvm_config_db#(int)::set(this, "*", "READ_COUNT", 0)        // We do not need read seq so we can set the count value to be zero
            // $error(get_type_name(), "READ_COUNT not set");
        `uvm_info(get_type_name(), $sformat("Scope %s", this), UVM_MEDIUM);
    endfunction

    task run_phase(uvm_phase phase);
    super.run_phase(phase);
    endtask

    // No run_phase we shall extend it from wr_rd test
    // To turn off the write/read seq we can set their respective count value to 0 in config_db

endclass


class fifo_read_error_test extends fifo_wr_rd_test;
`uvm_component_utils(fifo_read_error_test)

    `NEW_COMP
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
        if(!uvm_config_db#(int)::set(this, "*", "WRITE_COUNT", `DEPTH)) 
            $error(get_type_name(), "WRITE_COUNT not set");
        if(!uvm_config_db#(int)::set(this, "*", "READ_COUNT", `DEPTH+1))  // Count value is DEPTH + 1 to raise empty flag and reading one after empty flag
            $error(get_type_name(), "READ_COUNT not set");
    endfunction

    task run_phase(uvm_phase phase);
    super.run_phase(phase);
    endtask

endclass