class read_drv extends uvm_driver#(read_tx);
`uvm_component_utils(read_drv)

    virtual async_fifo_intf vif;
  static int count = 0;

  uvm_analysis_port#(read_tx) ap_port;       // We are creating this to send the delay to coverage

    `NEW_COMP

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual async_fifo_intf)::get(this, "", "PIF", vif)) 
            $error(get_type_name(), "Interface not found");
    endfunction

    task run_phase(uvm_phase phase);
    super.run_phase(phase);

    wait(vif.rst_i == 0);         // This will avoid reset and stimuli overlapping

    forever begin

        seq_item_port.get_next_item(req);
        ap_port.write(req);
        drive_tx(req);
        seq_item_port.item_done();
      $display("Read Driver seq count %0d", ++count);

    end

    endtask

    task drive_tx(read_tx tx);
        @(posedge vif.rd_clk_i);
        vif.rd_en_i <= 1;          // Defaulting to 1 as it is write seq
        @(posedge vif.rd_clk_i);
        tx.data = vif.rdata_o; 
        vif.wdata_i <= 0;

        // For inducing delay
        repeat(tx.delay) @(posedge vif.rd_clk_i);  // waits for delay cycles long
        
    endtask

endclass