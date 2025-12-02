class read_base_seq extends uvm_sequence#(read_tx);
`uvm_object_utils(read_base_seq)

uvm_phase phase;

`NEW_OBJ

task pre_body();
    phase = get_starting_phase();
    if(phase != null) 
        phase.raise_objection(this);
    // phase.phase_done.set_drain_time(this, 100);
endtask

task post_body();
    if(phase != null) 
        phase.drop_objection(this);
endtask

endclass


class read_seq extends read_base_seq;
`uvm_object_utils(read_seq)

int tx_num;

`NEW_OBJ

task body();

    if(!uvm_config_db#(int)::get(get_sequencer(), "", "READ_COUNT", tx_num)) // We use get_sequencer() to set the context as the sequncer it runs rather than just "null"
            $error(get_type_name(), "READ_COUNT/tx_num not received");

    repeat(`DEPTH) begin
        `uvm_do(req);
    end
endtask

endclass