class write_mon extends uvm_monitor;
`uvm_component_utils(write_mon)

    virtual async_fifo_intf vif;
    uvm_analysis_port#(write_tx) ap_port;

    `NEW_COMP

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_port = new("ap_port", this);
        if(!uvm_config_db#(virtual async_fifo_intf)::get(this, "", "PIF", vif)) 
            $error(get_type_name(), "Interface not found");
    endfunction

    task run_phase(uvm_phase phase);
    super.run_phase(phase);

        forever begin

            @(posedge vif.wr_clk_i);

            if(vif.wr_en == 1) begin
                tx = write_tx::type_id::create("tx");
                tx.data = vif.wdata_i;
            end

        end

    endtask

endclass