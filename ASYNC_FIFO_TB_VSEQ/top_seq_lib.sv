class top_base_seq extends uvm_sequence;
`uvm_object_utils(top_base_seq)

`NEW_OBJ

uvm_phase phase;

task pre_body();
    phase = get_starting_phase();
    if(phase != null)
        phase.raise_objection(this)
endtask

task post_body();
    phase = get_starting_phase();
    if(phase != null)
        phase.drop_objection(this)
endtask

endclass


class wr_rd_top_seq extends top_base_seq;
`uvm_object_utils(wr_rd_top_seq)
    
    `NEW_OBJ

    write_seq write_seq_i;      // We don't create objets because we map these to ones in agent in environment
    read_seq read_seq_i;

    `uvm_declare_p_sequencer(top_sqr)   // P_SEQUENCER DECLARATION

    task body();

        `uvm_do_on(write_seq_i, p_sequencer.write_sqr_i);
        `uvm_do_on(read_seq_i,  p_sequencer.read_seq_i);

    endtask

endclass


class concurrent_wr_rd_top_seq extends top_base_seq;
`uvm_object_utils(concurrent_wr_rd_top_seq)

write_delay_seq write_seq_i;
read_delay_seq read_seq_i;

`uvm_declare_p_sequencer(top_sqr)

`NEW_OBJ

task body();

    fork 
        `uvm_do_on(write_seq_i, p_sequencer.write_sqr_i );
        `uvm_do_on(read_seq_i,  p_sequencer.read_sqr_i);
    join

endtask


endclass