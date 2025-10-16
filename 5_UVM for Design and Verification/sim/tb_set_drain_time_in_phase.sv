module tb_set_drain_time_in_phase;

class test extends uvm_test;
    `uvm_component_utils(test)
    
    env e;
    my_seq seq;
    
    function new(string name = "test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);
    endfunction
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 100);                 // Setting drain time to 100
        seq = my_seq::type_id::create("seq");                // Also make sure two args and "this" comes first then the drain time
        seq.start(e.agt.seqr);
        
        phase.drop_objection(this);
    endtask
endclass

// ✓ ADDED: Initial block to run the test
initial begin
    run_test("test");
end


endmodule