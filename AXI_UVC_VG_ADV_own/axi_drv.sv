class axi_drv extends uvm_driver#(axi_tx);
`uvm_component_utils(axi_drv)

    `NEW_COMP
    
    axi_tx tx;
    virtual axi_intf vif;
    bit [`ADDR_BUS_WIDTH-1:0] addr_t;
    bit [`DATA_BUS_WIDTH/8-1:0] wstrb_t; 
    bit [`DATA_BUS_WIDTH-1:0] data; 
    bit [`DATA_BUS_WIDTH-1:0] data_ref;
    int strb_position;


    // Semaphores for Write_Data and Write_Response
  	semaphore wa_smp = new(1);
    semaphore wd_smp = new(1);
    semaphore wr_smp = new(1);
  	semaphore ra_smp = new(1);
    semaphore rd_smp = new(1);

    function void build(); //_phase(uvm_phase phase);
        if(!uvm_config_db#(virtual axi_intf)::get(null, "", "PIF", vif))
            `uvm_error(get_type_name(), "Interface not able to be retireved");
    endfunction

    task run(); //_phase(uvm_phase phase);
        // super.run_phase(phase);

        forever begin

            seq_item_port.get_next_item(req);
            // req.print();
            fork 
                drive_tx(req);
            join
            seq_item_port.item_done();
            #70;

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
      	wa_smp.get(1);
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
		wa_smp.put(1);
        @(posedge vif.aclk);

        reset_write_addr_channel();

    endtask

    task write_data_phase(axi_tx tx);
            wd_smp.get(1);                        // You get semaphore before for loop --. Interleaving NOT supported
        for(int i = 0; i <= tx.burst_len; i++) begin
//             wd_smp.get(1);                           // You get semaphore after for loop --. Interleaving supported
            @(posedge vif.aclk);
            // Making adjustments or strb
            addr_t = tx.addr + i * ( 2**tx.burst_size);
            strb_position = addr_t % (`DATA_BUS_WIDTH/8);
            wstrb_t = '0;
            for(int k = 0; k < 2**tx.burst_size; k++) begin
                wstrb_t[k] = 1'b1;
            end
            wstrb_t <<= strb_position;
            data = tx.dataQ.pop_front();
            foreach(wstrb_t[j]) begin
                if(wstrb_t[j]) begin
                    vif.wdata[j*8 +: 8] <= data[j*8 +: 8];
                    data_ref[j*8 +: 8] = data[j*8 +: 8];
                end
                else begin
                    vif.wdata[j*8 +: 8] <= '0;
                    data_ref[j*8 +: 8] = '0;
                end
            end
            `uvm_info("DRV_DATA", $sformatf("................... data_ref = %h, wstrb_t = %b, strb_pos=%0d, addr = %h ", data_ref,  wstrb_t, strb_position, addr_t), UVM_MEDIUM);
            // vif.wdata     <=    data ;            
            vif.wstrb     <=     wstrb_t;
            vif.wid       <=     tx.tx_id;
            vif.wvalid    <=     1;
            vif.wlast     <=     (i == tx.burst_len) ? 1 : 0;

            wait(vif.wready == 1);
//             wd_smp.put(1);                          // You put semaphore for each "for" loop --. Interleaving supported

        end
        // `uvm_info("DRV_END", $sformatf("========================================================================= "), UVM_MEDIUM);
            // vif.wdata     <=    data ;            
        wd_smp.put(1);                          // You put semaphore after for loop --. Interleaving NOT supported
        @(posedge vif.aclk);

         reset_write_data_channel();

    endtask

    task write_resp_phase(axi_tx tx);

        wr_smp.get(1);
        while(vif.bvalid == 0) begin
            @(posedge vif.aclk);
        end
        
        vif.bready    <=     1;

        @(posedge vif.aclk);
        
        vif.bready    <=     0;
        @(posedge vif.aclk);
        wr_smp.put(1);

    endtask

    task read_addr_phase(axi_tx tx);
      	ra_smp.get(1);
        @(posedge vif.aclk);
        vif.arid       <=     tx.tx_id;
        vif.araddr     <=     tx.addr;
        vif.arlen      <=     tx.burst_len;
        vif.arsize     <=     tx.burst_size;
        vif.arburst    <=     tx.burst_type;
        vif.arlock     <=     tx.lock;
        vif.arcache    <=     tx.cache;
        vif.arprot     <=     tx.prot;
        vif.arvalid    <=     1'b1;

      	wait(vif.arready == 1'b1);
		ra_smp.put(1);
        @(posedge vif.aclk);

        reset_read_addr_channel();

    endtask

    task read_data_phase(axi_tx tx);
      	
		rd_smp.get(1);
		for(int i = 0; i <= tx.burst_len; i++) begin
			
          	// rd_smp.get(1);
            while(vif.rvalid == 0) begin
                @(posedge vif.aclk);
            end
            
            vif.rready    <=     1;
            
            @(posedge vif.aclk);
            
            vif.rready    <=     0;
            // rd_smp.get(1);
        end
      	rd_smp.put(1);

    endtask

//     -------   RESET TASKS ----------    // 

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

    task reset_write_data_channel();

        vif.wdata     <=     0;
        vif.wstrb     <=     0;
        vif.wid       <=     0;
        vif.wvalid    <=     0;
        vif.wlast     <=     0;

    endtask
  
  	task reset_read_addr_channel();

        vif.arid       <=    0; 
        vif.araddr     <=    0; 
        vif.arlen      <=    0; 
        vif.arsize     <=    0; 
        vif.arburst    <=    0; 
        vif.arlock     <=    0; 
        vif.arcache    <=    0; 
        vif.arprot     <=    0; 
        vif.arvalid    <= 	 0; 

    endtask
       

endclass //