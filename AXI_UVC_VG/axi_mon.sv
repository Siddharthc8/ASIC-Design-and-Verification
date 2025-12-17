class axi_mon extends uvm_monitor;
`uvm_component_utils(axi_mon)

`NEW_COMP

axi_tx tx;
virtual axi_intf vif;

uvm_analysis_port#(axi_tx) ap_port;

function void build(); //_phase(uvm_phase phase);

    ap_port = new("ap_port", this);
    if(!uvm_config_db#(virtual axi_intf)::get(null, "", "PIF", vif))
        `uvm_error(get_type_name(), "Interface not able to be retireved");
endfunction

task run(); //_phase(uvm_phase phase);
    // super.run_phase(phase);

    // forever begin

        `uvm_info(get_type_name(), "Run Phase on Monitor tx", UVM_MEDIUM);

    // end

endtask


endclass