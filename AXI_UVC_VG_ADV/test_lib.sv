class axi_base_test extends uvm_test;
`uvm_component_utils(axi_base_test)

axi_env env;

`NEW_COMP

function void build(); //_phase(uvm_phase phase);
    // super.build_phase(phase);
    env = axi_env::type_id::create("env", this);
endfunction

function void end_of_elaboration(); //_phase(uvm_phase phase);
    // super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
    factory.print();   // This is not available in UVM 1.2 but we have made something int eh common file to accomodate this
endfunction

function void report();
    if(axi_common::num_matches == axi_common::total_beats && axi_common::num_mismatches == 0) begin
        `uvm_info("Status", $sformatf("=========================================="), UVM_MEDIUM);
        `uvm_info("Status", $sformatf(" '%s' Test Passed | total_beats = %d ", get_type_name(), axi_common::total_beats), UVM_MEDIUM);
        `uvm_info("Status", $sformatf("=========================================="), UVM_MEDIUM);
    end
    else begin
        `uvm_info("Status", $sformatf("=========================================="), UVM_MEDIUM);
        `uvm_error("Status", $sformatf(" '%s' Test Failed | total_beats = %d,  matches = %d | mismatches = %d ", get_type_name(), axi_common::total_beats, axi_common::num_matches, axi_common::num_mismatches));
        `uvm_info("Status", $sformatf("=========================================="), UVM_MEDIUM);
    end
endfunction


endclass


class axi_wr_rd_test extends axi_base_test;
`uvm_component_utils(axi_wr_rd_test)



    `NEW_COMP

    function void build();
        super.build();
        uvm_config_db#(int)::set(null, "*", "COUNT", axi_common::total_tx_count);
    endfunction

    task run_phase(uvm_phase phase);

        axi_n_wr_n_rd_seq wr_rd_seq;
        wr_rd_seq = axi_n_wr_n_rd_seq::type_id::create("wr_rd_seq");
        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 1500);
        wr_rd_seq.start(env.m_agent.sqr);
        phase.drop_objection(this);

    endtask


endclass //