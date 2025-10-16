module tb_driver_sequencer_comm;


/*
    Driver calls the seq_item_port.get_next_item
    Sequencer implements the get_next_item by getting item from sequence in the sequence lirary
    Sequencer sends this item to Driver
    Driver drives the item to DUT
    Driver send the resp/ack seq_item_port.item_done(rsp) to the sequencer --> NOte: rsp is optional as it corresponds to bi-directional comm 
    If there is a rsp mentioned then the sequence calls the get_response(rsp)

*/

class transaction extends uvm_sequence_item;

    rand bit psel;
    rand bit penable;
    rand bit [31:0] paddr;
    rand bit [31:0] pwdata;
    rand bit [31:0] prdata;
    rand bit pready;
    rand bit pslverr;

    function new(string name = "transaction");
        super.new(name);
    endfunction

    `uvm_object_utils_begin(transaction)
    
    `uvm_field_int(psel, UVM_ALL_ON)
    `uvm_field_int(penable, UVM_ALL_ON)
    `uvm_field_int(paddr, UVM_ALL_ON)
    `uvm_field_int(pwdata, UVM_ALL_ON)
    `uvm_field_int(prdata, UVM_ALL_ON)
    `uvm_field_int(pready, UVM_ALL_ON)
    `uvm_field_int(pslverr, UVM_ALL_ON)

    `uvm_object_utils_end


endclass

class sequencer extends uvm_sequencer#(transaction);
`uvm_component_utils(sequencer)

    function new(string name = "sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass

class my_seq extends uvm_sequence#(transaction);
`uvm_object_utils(my_seq)

    transaction tr;

    function new(string name = "my_seq");
        super.new(name);
    endfunction

    task body();

        repeat(20) begin

            tr = transaction::type_id::create("tr");
            start_item(tr);
            assert(tr.randomize());
            finish_item(tr);

        end

    endtask


endclass

class driver extends uvm_driver#(transaction);
`uvm_component_utils(driver)

        function new(string name = "driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            // transaction tr;
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                
                transaction tr;
                
                seq_item_port.get_next_item(tr);

                    tr.print();

                seq_item_port.item_done();

            end
            
        endtask



endclass

class agent extends uvm_agent;
    `uvm_component_utils(agent)
    
    driver drv;
    sequencer seqr;
    
    function new(string name = "agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = driver::type_id::create("drv", this);
        seqr = sequencer::type_id::create("seqr", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass

class env extends uvm_env;
    `uvm_component_utils(env)
    
    agent agt;
    
    function new(string name = "env", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = agent::type_id::create("agt", this);
    endfunction
endclass

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
        
        seq = my_seq::type_id::create("seq");
        seq.start(e.agt.seqr);
        phase.phase_done.set_drain_time(this, 100);
        #100;
        phase.drop_objection(this);
    endtask
endclass

initial begin
    run_test("test");
end

endmodule

