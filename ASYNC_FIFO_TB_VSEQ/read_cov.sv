class read_cov extends uvm_subscriber#(read_tx);
`uvm_component_utils(read_cov)

    read_tx tx;

    covergroup rd_cg;
        option.per_instance = 1;
        RD_DELAY_CP : coverpoint tx.delay {
            bins ZERO = {0};
            bins LOWER = {[1:3]};
            bins MEDIUM = {[4:6]};
            bins HIGHER = {[7:`MAX_RD_DELAY]};

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


    // Extra from claude to print coverage in EDA only
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_type_name(), 
                  $sformatf("\n========================================\n READ COVERAGE REPORT\n========================================\n Read Coverage = %.2f%%\n========================================", 
                  rd_cg.get_coverage()), 
                  UVM_LOW)
    endfunction

endclass