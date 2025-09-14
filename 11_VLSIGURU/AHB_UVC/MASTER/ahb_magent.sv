class ahb_magent extends uvm_agent;
`uvm_component_utils(ahb_magent)
    
    ahb_drv drv;
    ahb_seq sqr;
    ahb_mon mon;
    ahb_cov cov;

    function new(string name = "ahb_magent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = ahb_drv::type_id::create("ahb_drv", this);    
        sqr = ahb_sqr::type_id::create("ahb_sqr", this);    
        mon = ahb_mon::type_id::create("ahb_mon", this);    
        cov = ahb_cov::type_id::create("ahb_cov", this);    
    endfunction

    function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
        mon.ap_port.connect(cov.analysis_export);   // analysis_export is declared in uvm_subscriber
    endfunction

endclass
