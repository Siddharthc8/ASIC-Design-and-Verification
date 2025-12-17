class axi_cov extends uvm_subscriber#(axi_tx);
`uvm_component_utils(axi_cov);

// `NEW_COMP.       // Don't do we need to declare covergroup

axi_tx tx;

covergroup axi_cg;
    coverpoint tx.addr {

        option.auto_bin_max = 8;

    }
endgroup


function new(string name = "", uvm_component parent = null);
    super.new(name, parent);

    axi_cg = new();

endfunction

function void write(axi_tx t);

    tx = new t;
    axi_cg.sample();

endfunction

endclass