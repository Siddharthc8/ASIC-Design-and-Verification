class write_cov extends uvm_subscriber#(write_tx);
`uvm_component_utils(write_cov)

    write_tx tx;

    covergroup wr_cg;
        //
    endgroup

    function new(string name, uvm_component parent);
    super.new(name, parent);
        wr_cg = new();
    endfunction
    
    function void write(write_tx t);    // Get the argument and cast it on the handle we created

        $cast(tx, t);
        wr_cg.sample();
    endfunction

endclass