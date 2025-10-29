class write_drv extends uvm_driver#(write_tx);
`uvm_component_utils(write_drv)

    virtual async_fifo_intf vif;

    `NEW_COMP

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual async_fifo_intf)::get(this, "", "PIF", vif)) 
            $error(get_type_name(), "Interface not found");
    endfunction

    task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin

        seq_item_port.get_next_item(req);
        $display("Entry-2 - driver calling drive tx");
        drive_tx(req);
        seq_item_port.item_done();

    end

    endtask

    task drive_tx(write_tx tx);
        $display("Entry-3 - inside drive tx");
        @(posedge vif.wr_clk_i);
        vif.wr_en_i <= 1;          // Defaulting to 1 as it is write seq
        vif.wdata_i <= tx.data;
        $display("Entry-4 - Done driving");
        @(posedge vif.wr_clk_i);
        vif.wr_en_i <= 0; 
        vif.wdata_i <= 0;
    endtask

endclass