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


class wr_rd_fifo_test extends async_fifo_base_test;
`uvm_component_utils(wr_rd_fifo_test)

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
    task run_phase(uvm_phase phase);
        write_seq write_seq_i;
        read_seq read_seq_i;
        write_seq_i = write_seq::type_id::create("write_seq_i");
        read_seq_i = read_seq::type_id::create("read_seq_i");

        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 100);
        write_seq_i.start(env.write_agent.sqr);
        read_seq_i.start(env.read_agent.sqr);
        phase.drop_objection(this);
    endtask

endclass