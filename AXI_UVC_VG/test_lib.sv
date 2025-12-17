class axi_base_test extends uvm_test;
`uvm_component_utils(axi_base_test)

axi_env env;

`NEW_COMP

function void build; //_phase(uvm_phase phase);
    // super.build_phase(phase);
    env = axi_env::type_id::create("env", this);
endfunction

function void end_of_elaboration; //_phase(uvm_phase phase);
    // super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
    factory.print();   // This is not available in UVM 1.2 but we have made something int eh common file to accomodate this
endfunction


endclass