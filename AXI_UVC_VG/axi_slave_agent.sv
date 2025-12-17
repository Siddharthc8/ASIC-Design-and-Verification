class axi_slave_agent extends uvm_agent;
`uvm_component_utils(axi_slave_agent)

`NEW_COMP

axi_responder  responder;
axi_mon mon;

function void build(); //_phase(uvm_phase phase);
// super.new(phase);

    responder = axi_responder::type_id::create("responder", this);
    mon = axi_mon::type_id::create("mon", this);

endfunction

// There are no connection for agent when we use responder only the slave's monitor connects to the sbd
function void connect(); //_phase(uvm_phase phase);
// super.build_phase(phase);
    // 
endfunction

endclass