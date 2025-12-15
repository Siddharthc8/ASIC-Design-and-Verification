class read_mon extends uvm_monitor;
`uvm_component_utils(read_mon)

    virtual async_fifo_intf vif;
    uvm_analysis_port#(read_tx) ap_port;
    read_tx tx;

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

            @(vif.read_mon_cb);  // Use MONITOR clocking block

            if(vif.read_mon_cb.rd_en_i == 1) begin  // Now reading INPUT
                // Raise objection to keep simulation alive
                phase.raise_objection(this, "Read monitor processing transaction");
              
                tx = read_tx::type_id::create("tx");
                @(vif.read_mon_cb);  // Wait one cycle for data to be valid
                tx.data = vif.read_mon_cb.rdata_o;   // Now reading INPUT
                tx.error = vif.read_mon_cb.rd_error_o;
                tx.empty = vif.read_mon_cb.empty_o;
                ap_port.write(tx);
//                 $display("Read Monitor: Captured data = 0x%0h at time %0t", tx.data, $time);
              
                // Drop objection after processing
                phase.drop_objection(this, "Read monitor done processing");
            end

        end

    endtask

endclass