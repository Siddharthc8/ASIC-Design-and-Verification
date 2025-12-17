class axi_responder extends uvm_component;
`uvm_component_utils(axi_responder)

    `NEW_COMP

    axi_tx tx;
    virtual axi_intf vif;

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
            end

            if(vif.wvalid == 1'b1) begin
                vif.wready <= 1'b1;
            end

        end

    endtask


endclass