class apb_base_test extends uvm_test;
`uvm_component_utils(apb_base_test)
    
    apb_env env;

    function new(string name = apb_env, uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `uvm_info("APB_UVC", "Test: Build_phase", UVM_NONE);
        env = ahb_env::type_id::create("env", this);

    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);

        `uvm_info("TB_HIERARCHY", this.sprint(), UVM_NONE);
    endfunction


    endclass
