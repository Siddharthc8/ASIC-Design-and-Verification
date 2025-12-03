class read_cov extends uvm_subscriber#(read_tx);
`uvm_component_utils(read_cov)

    read_tx tx;

    covergroup rd_cg;
        RD_DELAY_CP : coverpoint tx.delay {
            option.autobin_max = 10;

        }
    endgroup

    function new(string name, uvm_component parent);
    super.new(name, parent);
        rd_cg = new();
    endfunction
    
    function void write(read_tx t);    // Get the argument as "t" and cast it on the handle we created

        $cast(tx, t);
        rd_cg.sample();
    endfunction

endclass