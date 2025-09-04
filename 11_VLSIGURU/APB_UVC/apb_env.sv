class apb_env extends uvm_env;
`uvm_component_utils(apb_env)
    
    

    function new(string name = "apb_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function build_phase(uvm_phase phase);
    
    endfunction


endclass
