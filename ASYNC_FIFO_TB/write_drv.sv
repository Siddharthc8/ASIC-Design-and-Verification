class write_drv extends uvm_driver#(write_tx);
`uvm_component_utils(write_drv)

  virtual async_fifo_intf vif;
  static int count = 0;

  uvm_analysis_port#(write_tx) ap_port;       // We are creating this to send the delay to coverage

    `NEW_COMP

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_port = new("ap_port", this);
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
      
      $display("Write Driver seq count %0d", ++count);

    end

    endtask

    task drive_tx(write_tx tx);
//         $display("Entry-3 - inside drive tx");
        @(posedge vif.wr_clk_i);
        vif.wr_en_i <= 1;          // Defaulting to 1 as it is write seq
        vif.wdata_i <= tx.data;
        @(posedge vif.wr_clk_i);
        vif.wr_en_i <= 0; 
        vif.wdata_i <= 0;

        // For inducing delay
        repeat(tx.delay) @(posedge vif.wr_clk_i);  // waits for delay cycles long
        
    endtask

endclass