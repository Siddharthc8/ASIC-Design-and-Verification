
module axi_salve (
    axi_int.slave_mp vif
);

    axi_tx rd_tx;
    axi_tx wr_tx;
    bit [31:0] mem [*];

    always @(posedge vif.aclk) begin // {

            if(vif.slave_cb.awvalid == 1'b1) begin // {
                vif.slave_cb.awready <= 1'b1;
                wr_tx = new("wr_tx");
                // Remembering all read addr info
                wr_tx.tx_id          =     vif.slave_cb.awid;
                wr_tx.addr           =     vif.slave_cb.awaddr;
                wr_tx.burst_len      =     vif.slave_cb.awlen;
                wr_tx.burst_size     =     vif.slave_cb.awsize;
                wr_tx.burst_type     =     vif.slave_cb.awburst;
            end // }
            else begin // {
                vif.slave_cb.awready <= 1'b0;
            end // }

            if(vif.slave_cb.wvalid == 1'b1) begin // {
                vif.slave_cb.wready <= 1'b1;
                `uvm_info(get_type_name(), $sformatf("Writing at addr = %h, data = %h", wr_tx.addr, vif.slave_cb.wdata), UVM_MEDIUM);
                mem[wr_tx.addr] = vif.slave_cb.wdata;          //NOTE :// We are storing byte by byte in sbd
                wr_tx.addr += 2**wr_tx.burst_size;
                if(vif.slave_cb.wlast == 1) begin   // wlast and wvalid also should be high
                    write_resp_phase(vif.slave_cb.wid);
                end
            end
            else begin // {
                vif.slave_cb.wready <= 1'b0;
            end // }

            if(vif.slave_cb.arvalid == 1'b1) begin // {
                vif.slave_cb.arready <= 1'b1;
                rd_tx = new("rd_tx");
                // Remembering all read addr info
                rd_tx.tx_id          =     vif.slave_cb.arid;
                rd_tx.addr           =     vif.slave_cb.araddr;
                rd_tx.burst_len      =     vif.slave_cb.arlen;
                rd_tx.burst_size     =     vif.slave_cb.arsize;
                rd_tx.burst_type     =     vif.slave_cb.arburst;

                read_data_phase(vif.slave_cb.arid);
            end // }
            else begin // {
                vif.slave_cb.arready <= 1'b0;
            end // }



        end // }


    task write_resp_phase(bit [3:0] id);
        // @(vif.slave_cb.aclk);
        vif.slave_cb.bid           <=      id;
        vif.slave_cb.bresp         <=      OKAY;
        vif.slave_cb.bvalid        <=      1;
        wait(vif.slave_cb.bready == 1);

        @(vif.slave_cb);

        vif.slave_cb.bid           <=      0;
        vif.slave_cb.bresp         <=      0;
        vif.slave_cb.bvalid        <=      0;
         
    endtask


  task read_data_phase(bit [3:0] id);

        for(int i = 0; i <= rd_tx.burst_len; i++) begin // {}
            @(vif.slave_cb);
            vif.slave_cb.rdata     <=      mem[rd_tx.addr];
            rd_tx.addr    +=      2**rd_tx.burst_size;
            vif.slave_cb.rid       <=      id;
            vif.slave_cb.rlast     <=      (i == rd_tx.burst_len) ? 1 : 0;
            vif.slave_cb.rvalid    <=      1;

            wait(vif.slave_cb.rready == 1);

        end // }

        @(vif.slave_cb);

        reset_read_data();

    endtask

    task reset_read_data();

        vif.slave_cb.rdata     <=      0;
        vif.slave_cb.rid       <=      0;
        vif.slave_cb.rlast     <=      0;
        vif.slave_cb.rvalid    <=      0;

    endtask

endmodule //