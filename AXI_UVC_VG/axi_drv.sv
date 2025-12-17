class axi_drv extends uvm_driver#(axi_tx);
`uvm_component_utils(axi_drv)

`NEW_COMP

axi_tx tx;
virtual axi_intf vif;

function void build; //_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual axi_intf)::get(null, "", "PIF", vif))
        `uvm_error(get_type_name(), "Interface not able to be retireved");
endfunction

task run; //_phase(uvm_phase phase);
    // super.run_phase(phase);

    forever begin

        seq_item_port.get_next_item(req);
        drive_tx(req);
        seq_item_port.item_done();

    end

endtask

task drive_tx(axi_tx tx);

    `uvm_info(get_type_name(), "Driving tx", UVM_MEDIUM);

endtask


endclass