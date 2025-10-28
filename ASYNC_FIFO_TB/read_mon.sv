class read_mon extends uvm_monitor;
`uvm_component_utils(read_mon)

    virtual async_fifo_intf vif;
    uvm_analysis_port#(read_tx) ap_port;

    `NEW_COMP

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_port = new("ap_export", this);
        if(!uvm_config_db#(virtual async_fifo_intf)::get(this, "", "PIF", vif)) 
            $error(get_type_name(), "Interface not found");
    endfunction

    task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin

        //

    end

    endtask

endclass