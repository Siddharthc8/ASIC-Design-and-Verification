class axi_drv extends uvm_driver#(axi_tx);
`uvm_component_utils(axi_drv)

    `NEW_COMP

    axi_tx tx;
    virtual axi_intf vif;

    function void build(); //_phase(uvm_phase phase);
        if(!uvm_config_db#(virtual axi_intf)::get(null, "", "PIF", vif))
            `uvm_error(get_type_name(), "Interface not able to be retireved");
    endfunction

    task run(); //_phase(uvm_phase phase);
        // super.run_phase(phase);

        forever begin

            seq_item_port.get_next_item(req);
            drive_tx(req);
            seq_item_port.item_done();

        end

    endtask

    task drive_tx(axi_tx tx);

        `uvm_info(get_type_name(), "Driving tx", UVM_MEDIUM);
        if (tx.wr_rd == 1) begin
            write_addr_phase(tx);
            write_data_phase(tx);
            write_resp_phase(tx);
        end
        else begin
            read_addr_phase(tx);
            read_data_phase(tx);
        end
    endtask

    task write_addr_phase(axi_tx tx);

        @(posedge vif.aclk);
        vif.awid       <=     tx.tx_id;
        vif.awaddr     <=     tx.addr;
        vif.awlen      <=     tx.burst_len;
        vif.awsize     <=     tx.burst_size;
        vif.awburst    <=     tx.burst_type;
        vif.awlock     <=     tx.lock;
        vif.awcache    <=     tx.cache;
        vif.awprot     <=     tx.prot;
        vif.awvalid    <=     1'b1;

        wait(vif.awready == 1'b1);
        @(posedge vif.aclk);

        reset_write_addr_channel();

    endtask

    task write_data_phase(axi_tx tx);



    endtask

    task write_resp_phase(axi_tx tx);



    endtask

    task read_addr_phase(axi_tx tx);



    endtask

    task read_data_phase(axi_tx tx);

        

    endtask


    task reset_write_addr_channel();

        vif.awid       <=    0; 
        vif.awaddr     <=    0; 
        vif.awlen      <=    0; 
        vif.awsize     <=    0; 
        vif.awburst    <=    0; 
        vif.awlock     <=    0; 
        vif.awcache    <=    0; 
        vif.awprot     <=    0; 
        vif.awvalid    <=    0; 

    endtask

endclass