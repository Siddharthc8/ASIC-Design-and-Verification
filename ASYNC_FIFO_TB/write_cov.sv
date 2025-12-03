class write_cov extends uvm_subscriber#(write_tx);
`uvm_component_utils(write_cov)

    write_tx tx;

    covergroup wr_cg;
        option.per_instance = 1;
        WR_DELAY_CP : coverpoint tx.delay {
            bins ZERO = {0};
            bins LOWER = {[1:3]};
            bins MEDIUM = {[4:6]};
            bins HIGHER = {[7:`MAX_WR_DELAY]};

        }
    endgroup

    function new(string name, uvm_component parent);
    super.new(name, parent);
        wr_cg = new();
    endfunction
    
    function void write(write_tx t);    // Get the argument and cast it on the handle we created

        $cast(tx, t);
        wr_cg.sample();
    endfunction


    // Extra from clause to print coverage in EDA
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_type_name(), 
                  $sformatf("\n========================================\n WRITE COVERAGE REPORT\n========================================\n Write Coverage = %.2f%%\n========================================", 
                  wr_cg.get_coverage()), 
                  UVM_LOW)
    endfunction

endclass