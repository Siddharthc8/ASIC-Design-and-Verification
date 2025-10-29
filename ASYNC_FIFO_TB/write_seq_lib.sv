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

`NEW_OBJ

task body();
    repeat(`DEPTH) begin
        $display("Entry-1 - generate item in write sequence");
        `uvm_do(req);
    end
endtask

endclass