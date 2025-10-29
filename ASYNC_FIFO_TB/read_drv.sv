class read_drv extends uvm_driver#(read_tx);
`uvm_component_utils(read_drv)

    virtual async_fifo_intf vif;

    `NEW_COMP

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual async_fifo_intf)::get(this, "", "PIF", vif)) 
            $error(get_type_name(), "Interface not found");
    endfunction

    task run_phase(uvm_phase phase);
    super.run_phase(phase);

    wait(vif.rst_i == 0);    // Waiting for reset so all reads happen after reset

    forever begin

        seq_item_port.get_next_item(req);
        drive_tx(req);
        seq_item_port.item_done();

    end

    endtask

    task drive_tx(read_tx tx);
        @(posedge vif.rd_clk_i);
        vif.rd_en_i <= 1;          // Defaulting to 1 as it is write seq
        @(posedge vif.rd_clk_i);
        tx.data = vif.rdata_o; 
        vif.wdata_i <= 0;
    endtask

endclass