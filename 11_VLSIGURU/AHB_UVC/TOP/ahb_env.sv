class ahb_env extends uvm_env;
`uvm_component_utils(ahb_env)
    
    ahb_magent magent;
    ahb_sagent sagent;

    function new(string name = "ahb_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function build_phase(uvm_phase phase);
        magent = ahb_magent::type_id::create("magent", this);
        sagent = ahb_sagent::type_id::create("sagent", this);
    endfunction


endclass
