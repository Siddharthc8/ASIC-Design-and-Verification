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
        drive_tx(req);
        seq_item_port.item_done();

    end

    endtask

    task drive_tx(write_tx tx);



    endtask

endclass