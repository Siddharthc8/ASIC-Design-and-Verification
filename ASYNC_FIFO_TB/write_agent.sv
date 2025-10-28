class write_agent extends uvm_agent;
`uvm_component_utils(write_agent)

`NEW_COMP

write_drv drv;
write_sqr sqr;
write_mon mon;
write_cov cov;

function void build_phase(uvm_phase phase);
super.build_phase(phase);
    drv = write_drv::type_id::create("drv", this);
    sqr = write_sqr::type_id::create("sqr", this);
    mon = write_mon::type_id::create("mon", this);
    cov = write_cov::type_id::create("cov", this);
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
    mon.ap_port.connect(cov.analysis_export);
endfunction

endclass