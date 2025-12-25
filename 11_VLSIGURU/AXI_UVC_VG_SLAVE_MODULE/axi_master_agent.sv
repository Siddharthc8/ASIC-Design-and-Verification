class axi_master_agent extends uvm_agent;
`uvm_component_utils(axi_master_agent)

`NEW_COMP

axi_sqr sqr;
axi_drv drv;
axi_mon mon;
axi_cov cov;

function void build(); //_phase(uvm_phase phase);
    // super.new(phase);

    sqr = axi_sqr::type_id::create("sqr", this);
    drv = axi_drv::type_id::create("drv", this);
    mon = axi_mon::type_id::create("mon", this);
    cov = axi_cov::type_id::create("cov", this);

endfunction


function void connect(); //_phase(uvm_phase phase);
// super.build_phase(phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
    mon.ap_port.connect(cov.analysis_export);
endfunction

endclass //