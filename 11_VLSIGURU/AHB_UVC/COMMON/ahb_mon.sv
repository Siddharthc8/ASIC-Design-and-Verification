class ahb_mon extends uvm_monitor;
`uvm_component_utils(ahb_mon)

    virtual ahb_intf vif;
    uvm_analysis_port#(ahb_tx) ap_port;

   `NEW_COMP
   
    function void build_phase(uvm_phase phase);
        //if(!uvm_config_db#(virtual ahb_intf)::get(this, "", "vif", vif)) 
            //`uvm_error("AHB_DRV", "Unable to access the interface");
        ap_port = new("ap_port", this);
        if(`uvm_resource_db#(virtual ahb_intf)::read_by_type("AHB", vif, this)) begin
            `uvm_error("RESOURCE_DB_ERROR_MON", "Unable to access the interface from resource_db");
        end
    endfunction

   task run_phase(uvm_phase phase);
            
   endtask

endclass
