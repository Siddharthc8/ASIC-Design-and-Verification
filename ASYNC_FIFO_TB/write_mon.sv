class write_mon extends uvm_monitor;
`uvm_component_utils(write_mon)

    virtual async_fifo_intf vif;
    uvm_analysis_port#(write_tx) ap_port;
    write_tx tx;

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

            @(vif.write_mon_cb);  // Use MONITOR clocking block

            if(vif.write_mon_cb.wr_en_i == 1) begin  // Now reading INPUT
                tx = write_tx::type_id::create("tx");
                tx.data = vif.write_mon_cb.wdata_i;   // Now reading INPUT
                tx.error = vif.write_mon_cb.wr_error_o;
                tx.full = vif.write_mon_cb.full_o;
                ap_port.write(tx);
//               $display("Write Monitor: Captured data = 0x%0d at time %0t", tx.data, $time);
            end

        end

    endtask

endclass