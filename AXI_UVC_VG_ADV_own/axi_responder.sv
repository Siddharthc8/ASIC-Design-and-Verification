class axi_responder extends uvm_component;
`uvm_component_utils(axi_responder)

    `NEW_COMP

    axi_tx rd_tx;
    axi_tx wr_tx;
    virtual axi_intf vif;
    semaphore rd_smp = new(1);

    bit [`DATA_BUS_WIDTH-1:0] wdata; 
    bit [`DATA_BUS_WIDTH-1:0] rdata;

    bit [`DATA_BUS_WIDTH-1:0] data_ref;

    bit [`STRB_WIDTH-1:0] wstrb;

    bit [`DATA_BUS_WIDTH-1:0] fifo [$];      // For Fixed
    bit [7:0] mem [*];                       // For wrap and INCR

    int unsigned lane_offset;
    // int unsigned base_addr;

    function void build(); //_phase(uvm_phase phase);
        if(!uvm_config_db#(virtual axi_intf)::get(null, "", "PIF", vif))
            `uvm_error(get_type_name(), "Interface unable to be retrieved");
    endfunction

    task run(); //_phase(uvm_phase phase);
        // super.run_phase(phase);

        `uvm_info(get_type_name(), "Run Phase on Responder tx", UVM_MEDIUM);

        forever begin

            @(vif.slave_cb);

            //----------------------------------------------------------------------------------------//
            //                                ADDR WRITE CHANNEL                                        
            //----------------------------------------------------------------------------------------//  

            if(vif.slave_cb.awvalid == 1'b1) begin
                vif.slave_cb.awready <= 1'b1;
                wr_tx = new("wr_tx");
                // Remembering all read addr info
                wr_tx.tx_id          =     vif.slave_cb.awid;
                wr_tx.addr           =     vif.slave_cb.awaddr;
                wr_tx.burst_len      =     vif.slave_cb.awlen;
                wr_tx.burst_size     =     vif.slave_cb.awsize;
                wr_tx.burst_type     =     vif.slave_cb.awburst;

                wr_tx.calculate_wrap_range();
            end
            else begin
                vif.slave_cb.awready <= 1'b0;
            end

            //----------------------------------------------------------------------------------------//
            //                                DATA WRITE CHANNEL                                        
            //----------------------------------------------------------------------------------------//

            if(vif.slave_cb.wvalid == 1'b1) begin
                vif.slave_cb.wready <= 1'b1;
                wdata = vif.slave_cb.wdata;
                wstrb = vif.slave_cb.wstrb;
                
                if( wr_tx.burst_type inside {INCR, WRAP} ) begin
                    
                    `uvm_info(get_type_name(), $sformatf("DATA at responder addr = %h, data = %h, strb = %b", wr_tx.addr, wdata, wstrb), UVM_MEDIUM);

                    lane_offset = wr_tx.addr % `STRB_WIDTH;
                    for (int j = 0; j < 2**wr_tx.burst_size; j++) begin
                        int lane = lane_offset + j;
                        if (wstrb[lane]) begin
                            mem[wr_tx.addr + j] = wdata[lane*8 +: 8];
                            `uvm_info("MEM_WRITE", $sformatf("mem[%h] = wdata[%d:%d]", wr_tx.addr+j,lane*8+8,lane*8), UVM_MEDIUM);
                        end
                    end
                    `uvm_info(get_type_name(), $sformatf("Writing at addr = %h, data = %h, strb = %b", wr_tx.addr, wdata, wstrb), UVM_MEDIUM);
                    wr_tx.addr += 2**wr_tx.burst_size;        // Incrementing the address by the burst_size
                    wr_tx.check_wrap();                                  // Resets the addr to lower_boundary when it reaches the upper boundary
                end
                // 
                else if( wr_tx.burst_type == FIXED ) begin
                    fifo.push_back( vif.slave_cb.wdata ); 
                end
                else begin
                    `uvm_error("WRITE RSVD_BURST_TYPE_ERROR", $sformatf("WRITE BURST_TYPE is neither INCR, WRAP, or FIXED"));
                end
            
                if(vif.slave_cb.wlast == 1) begin   // wlast and wvalid also should be high
                    write_resp_phase(vif.slave_cb.wid);
                end
            end
            else begin
                vif.slave_cb.wready <= 1'b0;
            end
            

            //----------------------------------------------------------------------------------------//
            //                                ADDR READ CHANNEL                                        
            //----------------------------------------------------------------------------------------//

            if(vif.slave_cb.arvalid == 1'b1) begin
                vif.slave_cb.arready <= 1'b1;
                rd_tx = new("rd_tx");
                // Remembering all read addr info
                rd_tx.tx_id          =     vif.slave_cb.arid;
                rd_tx.addr           =     vif.slave_cb.araddr;
                rd_tx.burst_len      =     vif.slave_cb.arlen;
                rd_tx.burst_size     =     vif.slave_cb.arsize;
                rd_tx.burst_type     =     vif.slave_cb.arburst;
                rd_tx.calculate_wrap_range();

                fork
                    read_data_phase(rd_tx);
                join_none

            end
            else begin
                vif.slave_cb.arready <= 1'b0;
            end
        end

    endtask


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


  task read_data_phase(axi_tx rd_tx);

        int rd_delay;

        rd_delay = $urandom_range(5,20);
        // repeat(rd_delay) @(vif.slave_cb);

        rd_smp.get(1);
        for(int i = 0; i <= rd_tx.burst_len; i++) begin

            // rd_smp.get(1);         // Semaphore to control overwriting on the read data channel

            @(vif.slave_cb);
            
            if( rd_tx.burst_type inside {INCR, WRAP} ) begin

                lane_offset = rd_tx.addr % `STRB_WIDTH;
                rdata = '0;
                for(int j = 0; j < 2**rd_tx.burst_size; j++) begin
                    int lane = lane_offset + j;
                    rdata[lane*8 +: 8] = mem[rd_tx.addr + j];  // Cleaner bit slice assignment
                end

                vif.slave_cb.rdata     <=      rdata;
                `uvm_info(get_type_name(), $sformatf("Reading to intf at addr = %h, data = %h", rd_tx.addr, rdata), UVM_MEDIUM);

                rd_tx.addr    +=      2**rd_tx.burst_size;          
                rd_tx.check_wrap();                                  // Resets the addr to lower_boundary when it reaches the upper boundary
            end
            else if( rd_tx.burst_type == FIXED ) begin
                rdata = fifo.pop_front();
                vif.slave_cb.rdata     <=      rdata;
                `uvm_info(get_type_name(), $sformatf("Reading at addr = %h, data = %h", rd_tx.addr, rdata), UVM_MEDIUM);
            end
            else begin
                `uvm_error("READ RSVD_BURST_TYPE_ERROR", $sformatf("READ BURST_TYPE is neither INCR, WRAP, or FIXED"));
            end

            vif.slave_cb.rid       <=      rd_tx.tx_id;
            vif.slave_cb.rlast     <=      (i == rd_tx.burst_len) ? 1 : 0;
            vif.slave_cb.rvalid    <=      1'b1;

            wait(vif.slave_cb.rready == 1);

            // rd_smp.put(1);              // Semaphore to control overwriting on the read data channel
        end
        rd_smp.put(1); 
        @(vif.slave_cb);               

        reset_read_data();

    endtask

    task reset_read_data();

        vif.slave_cb.rdata     <=      0;
        vif.slave_cb.rid       <=      0;
        vif.slave_cb.rlast     <=      0;
        vif.slave_cb.rvalid    <=      0;

    endtask

endclass //