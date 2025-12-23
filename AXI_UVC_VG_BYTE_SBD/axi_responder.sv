class axi_responder extends uvm_component;
`uvm_component_utils(axi_responder)

    `NEW_COMP

    axi_tx rd_tx;
    axi_tx wr_tx;
    virtual axi_intf vif;
    bit [31:0] mem [*];

    function void build(); //_phase(uvm_phase phase);
        if(!uvm_config_db#(virtual axi_intf)::get(null, "", "PIF", vif))
            `uvm_error(get_type_name(), "Interface not able to be retireved");
    endfunction

    task run(); //_phase(uvm_phase phase);
        // super.run_phase(phase);

        `uvm_info(get_type_name(), "Run Phase on Responder tx", UVM_MEDIUM);

        forever begin

            @(posedge vif.aclk);

            if(vif.awvalid == 1'b1) begin
                vif.awready <= 1'b1;
                wr_tx = new("wr_tx");
                // Remembering all read addr info
                wr_tx.tx_id          =     vif.awid;
                wr_tx.addr           =     vif.awaddr;
                wr_tx.burst_len      =     vif.awlen;
                wr_tx.burst_size     =     vif.awsize;
                wr_tx.burst_type     =     vif.awburst;

            end

            if(vif.wvalid == 1'b1) begin
                vif.wready <= 1'b1;
                `uvm_info(get_type_name(), $sformatf("Writing at addr = %h, data = %h", wr_tx.addr, vif.wdata), UVM_MEDIUM);
                mem[wr_tx.addr] = vif.wdata;
                wr_tx.addr += 2**wr_tx.burst_size;
                if(vif.wlast == 1) begin   // wlast and wvalid also should be high
                    write_resp_phase(vif.wid);
                end
            end

            if(vif.arvalid == 1'b1) begin
                vif.arready <= 1'b1;
                rd_tx = new("rd_tx");
                // Remembering all read addr info
                rd_tx.tx_id          =     vif.arid;
                rd_tx.addr           =     vif.araddr;
                rd_tx.burst_len      =     vif.arlen;
                rd_tx.burst_size     =     vif.arsize;
                rd_tx.burst_type     =     vif.arburst;

                read_data_phase(vif.arid);
            end
            else begin
                vif.arready <= 1'b0;
            end



        end

    endtask


    task write_resp_phase(bit [3:0] id);
        // @(posedge vif.aclk);
        vif.bid           <=      id;
        vif.bresp         <=      OKAY;
        vif.bvalid        <=      1;
        wait(vif.bready == 1);

        @(posedge vif.aclk);

        vif.bid           <=      0;
        vif.bresp         <=      0;
        vif.bvalid        <=      0;
         
    endtask


  task read_data_phase(bit [3:0] id);

        for(int i = 0; i <= rd_tx.burst_len; i++) begin
            @(posedge vif.aclk);
            vif.rdata     <=      mem[rd_tx.addr];
            rd_tx.addr    +=      2**rd_tx.burst_size;
            vif.rid       <=      id;
            vif.rlast     <=      (i == rd_tx.burst_len) ? 1 : 0;
            vif.rvalid    <=      1;

            wait(vif.rready == 1);

        end

        @(posedge vif.aclk);

        reset_read_data();

    endtask

    task reset_read_data();

        vif.rdata     <=      0;
        vif.rid       <=      0;
        vif.rlast     <=      0;
        vif.rvalid    <=      0;

    endtask

endclass