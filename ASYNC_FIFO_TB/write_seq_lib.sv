class write_base_seq extends uvm_sequence#(write_tx);
`uvm_object_utils(write_base_seq)

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


class write_seq extends write_base_seq;
`uvm_object_utils(write_seq)

int tx_num;

`NEW_OBJ

task body();

    if(!uvm_config_db#(int)::get(get_sequencer(), "", "WRITE_COUNT", tx_num))    // We use get_sequencer() to set the context as the sequncer it runs rather than just "null"
            $error(get_type_name(), "WRITE_COUNT/tx_num not received");

    repeat(tx_num) begin
        // $display("Entry-1 - generate item in write sequence");
        `uvm_do(req);
    end
endtask

endclass


class write_delay_seq extends write_base_seq;
`uvm_object_utils(write_seq)

int tx_num;
int write_delay;

`NEW_OBJ

task body();

    if(!uvm_config_db#(int)::get(get_sequencer(), "", "WRITE_COUNT", tx_num)) 
            $error(get_type_name(), "WRITE_COUNT/tx_num not received");

    repeat(tx_num) begin
        // $display("Entry-1 - generate item in write sequence");
        `uvm_do(req);
    end
endtask

endclass