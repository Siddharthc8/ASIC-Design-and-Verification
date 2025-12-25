class axi_mon extends uvm_monitor;
`uvm_component_utils(axi_mon)

`NEW_COMP

axi_tx wr_tx, rd_tx;
virtual axi_intf vif;

uvm_analysis_port#(axi_tx) ap_port;

function void build(); //_phase(uvm_phase phase);

    ap_port = new("ap_port", this);
    if(!uvm_config_db#(virtual axi_intf)::get(null, "", "PIF", vif))
        `uvm_error(get_type_name(), "Interface not able to be retireved");
endfunction

task run(); //_phase(uvm_phase phase);
    // super.run_phase(phase);

    forever begin

        @(posedge vif.aclk);

        if(vif.awvalid && vif.awready) begin
            wr_tx = axi_tx::type_id::create("wr_tx");
            wr_tx.wr_rd         =    1;
            wr_tx.tx_id         =    vif.awid;
            wr_tx.addr          =    vif.awaddr;
            wr_tx.burst_len     =    vif.awlen;
            wr_tx.burst_size    =    vif.awsize;
            wr_tx.burst_type    =    vif.awburst;
            wr_tx.lock          =    vif.awlock;
            wr_tx.prot          =    vif.awprot;
            wr_tx.cache         =    vif.awcache;
            `uvm_info(get_type_name(), "WRITE ADDR Phase on Monitor tx done", UVM_DEBUG);
        end

        // ID not smapled because we are assuming it is the same for all the phases
        if(vif.wvalid && vif.wready) begin
            wr_tx.dataQ.push_back(vif.wdata);
            wr_tx.strbQ.push_back(vif.wstrb);
            `uvm_info(get_type_name(), "DATA Phase on Monitor tx done", UVM_DEBUG);
        end

        // ID not smapled because we are assuming it is the same for all the phases
        if(vif.bvalid && vif.bready) begin
            wr_tx.respQ.push_back(vif.bresp);
            `uvm_info(get_type_name(), "RESP Phase on Monitor tx done", UVM_DEBUG);

            ap_port.write(wr_tx);
        end

        if(vif.arvalid && vif.arready) begin
            rd_tx = axi_tx::type_id::create("rd_tx");
            rd_tx.wr_rd         =    0;
            rd_tx.tx_id         =    vif.arid;
            rd_tx.addr          =    vif.araddr;
            rd_tx.burst_len     =    vif.arlen;
            rd_tx.burst_size    =    vif.arsize;
            rd_tx.burst_type    =    vif.arburst;
            rd_tx.lock          =    vif.arlock;
            rd_tx.prot          =    vif.arprot;
            rd_tx.cache         =    vif.arcache;
            `uvm_info(get_type_name(), "READ ADDR Phase on Monitor tx done", UVM_DEBUG);
        end

        if(vif.rvalid && vif.rready) begin
            rd_tx.dataQ.push_back(vif.rdata);
            rd_tx.respQ.push_back(vif.rresp);

            if(vif.rlast)
                ap_port.write(rd_tx);
            
            `uvm_info(get_type_name(), "DATA Phase on Monitor tx done", UVM_DEBUG);
        end

        //`uvm_info(get_type_name(), "Run Phase on Monitor tx done", UVM_DEBUG);

    end

endtask


endclass //