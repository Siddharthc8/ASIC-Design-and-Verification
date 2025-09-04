class ahb_base_test extends uvm_test;
`uvm_component_utils(ahb_base_test)
    
    ahb_env env;

    function new(string name = "ahb_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `uvm_info("APB_UVC", "Test: Build_phase", UVM_NONE);
        env = ahb_env::type_id::create("env", this);
        uvm_config_db#(int)::set(this, "env.magent.*", "master_slave_f", 1);
        uvm_config_db#(int)::set(this, "env.sagent.*", "master_slave_f", 0);

    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);

        `uvm_info("TB_HIERARCHY", this.sprint(), UVM_NONE);

    endfunction


endclass


class ahb_wr_rd_test extends ahb_base_test;
`uvm_component_utils(ahb_base_test)
    
    `NEW_COMP

    function build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
    
    virtual task run_phase();
        ahb_wr_rd_seq wr_rd_seq;
        wr_rd_seq = ahb_wr_rd_seq::type_id::create("wr_rd_seq");
        phase.phase_done.set_drain_time(this, 100);
        phase.raise_objection(this);
        wr_rd_seq.start(env.magent.sqr);
        phase.drop_objection(this);

    endtask

endclass
