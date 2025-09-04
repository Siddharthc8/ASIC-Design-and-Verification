class ahb_sagent extends uvm_agent;
`uvm_component_utils(ahb_sagent)
    
    ahb_drv drv;
    ahb_mon mon;

    function new(string name = "ahb_sagent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = ahb_drv::type_id::create("ahb_drv", this);    
        mon = ahb_mon::type_id::create("ahb_mon", this);    
    endfunction

endclass
