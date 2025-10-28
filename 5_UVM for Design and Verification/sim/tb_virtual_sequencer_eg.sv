module tb_virtual_sequencer_eg;

//analogy: top_seq_v is like one of the projects. 
//         top_sqr is like one of the project managers and we want him to lead this project
//         There could be many project managers(sqrs) too

// The top_base_seq may look like this

class top_base_seq extends uvm_sequence;
    `uvm_object_utils(top_base_seq)

    // `uvm_declare_p_sequencer(top_sqr)         // Declare in the sub_sequence for reusability
    
    function new(string name = "top_base_seq");
        super.new(name);
    endfunction
    
    // Optional: pre_body and post_body tasks for common setup/cleanup
    task pre_body();
        // Common operations before any derived sequence starts
        uvm_phase phase = get_starting_phase();                   // Can also use "starting_phase" instead os just "phase"
        if (phase != null) begin
            phase.raise_objection(this, $sformatf("%s raise objection", get_name()));
            phase.phase_done.set_drain_time(this, 100);
        end
    endtask
    
    task post_body();
        // Common operations after any derived sequence completes
        if (phase != null) begin
            phase.drop_objection(this, $sformatf("%s drop objection", get_name()));
        end
    endtask
    
endclass


// Virtual Sequence

class top_seq_v extends top_base_seq;
    `uvm_object_utils(top_seq_v)
    `NEW_OBJ

    `uvm_declare_p_sequencer(top_sqr)      //   top_sqr becomes p_sequencer

    task body();

        apb_reset_seq reset_seq; 
        apb_configure_seq configure_seq;
        ahb_main1_seq main1_seq;
        ahb_main2_seq main2_seq;
        apb_main_seq apb_main_seq_i;
        ahb_shutdown_seq shutdown_seq;

        // Note we DO NOT create objects for sequences as we only connect them to their sequencers


        `uvm_do_on(reset_seq, p_sequencer.apb_sqr_i)          // What I think is to best NOT to use the actual handle -> top_sqr  X
        `uvm_do_on(configure_seq, p_sequencer.apb_sqr_i)      // p_seqeuncer is more like a common word that can be changed in the p_sequencer argument
        fork                                                  // Much more like a argument in a function
            `uvm_do_on(main1_seq, p_sequencer.ahb_sqr_i)
            `uvm_do_on(main2_seq, p_sequencer.ahb_sqr_i)
            `uvm_do_on(apb_main_seq_i, p_sequencer.apb_sqr_i)
        join
        `uvm_do_on(shutdown_seq, p_sequencer.ahb_sqr_i)
        
    endtask
endclass





// The top_sqr may look like this

class top_sqr extends uvm_sequencer;
    `uvm_component_utils(top_sqr)
    
    // Declare handles to sub-sequencers
    apb_sequencer apb_sqr_i;
    ahb_sequencer ahb_sqr_i;
    
    function new(string name = "top_sqr", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    
endclass


// The env class may look like this

class top_env extends uvm_env;

    top_sqr t_sqr;                // (Virtual)Top Sequencer declaration

    apb_agent apb_agt;           
    ahb_agent ahb_agt;
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        t_sqr = top_sqr::type_id::create("t_sqr", this);
        apb_agt = apb_agent::type_id::create("apb_agt", this);
        ahb_agt = ahb_agent::type_id::create("ahb_agt", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Connect virtual sequencer to actual sequencers
        t_sqr.apb_sqr_i = apb_agt.apb_sqr;
        t_sqr.ahb_sqr_i = ahb_agt.ahb_sqr;
    endfunction
endclass

// APB AGENT

class apb_agent extends uvm_agent;
    `uvm_component_utils(apb_agent)
    
    // Agent components
    apb_sequencer apb_sqr;
    apb_driver apb_drv;
    apb_monitor apb_mon;
    
    function new(string name = "apb_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Create sequencer and driver only if agent is active
        if (get_is_active() == UVM_ACTIVE) begin
            apb_sqr = apb_sequencer::type_id::create("apb_sqr", this);
            apb_drv = apb_driver::type_id::create("apb_drv", this);
        end
        
        // Monitor is created for both active and passive agents
        apb_mon = apb_monitor::type_id::create("apb_mon", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // Connect driver to sequencer only if active
        if (get_is_active() == UVM_ACTIVE) begin
            apb_drv.seq_item_port.connect(apb_sqr.seq_item_export);
        end
    endfunction
    
endclass

// AHB AGENT

class ahb_agent extends uvm_agent;
    `uvm_component_utils(ahb_agent)
    
    // Agent components
    ahb_sequencer ahb_sqr;
    ahb_driver ahb_drv;
    ahb_monitor ahb_mon;
    
    function new(string name = "ahb_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Create sequencer and driver only if agent is active
        if (get_is_active() == UVM_ACTIVE) begin
            ahb_sqr = ahb_sequencer::type_id::create("ahb_sqr", this);
            ahb_drv = ahb_driver::type_id::create("ahb_drv", this);
        end
        
        // Monitor is created for both active and passive agents
        ahb_mon = ahb_monitor::type_id::create("ahb_mon", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // Connect driver to sequencer only if active
        if (get_is_active() == UVM_ACTIVE) begin
            ahb_drv.seq_item_port.connect(ahb_sqr.seq_item_export);
        end
    endfunction
    
endclass

// APB and AHB Sequencers

class apb_sequencer extends uvm_sequencer #(apb_transaction);
    `uvm_component_utils(apb_sequencer)
    
    function new(string name = "apb_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass


class ahb_sequencer extends uvm_sequencer #(ahb_transaction);
    `uvm_component_utils(ahb_sequencer)
    
    function new(string name = "ahb_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass

endmodule