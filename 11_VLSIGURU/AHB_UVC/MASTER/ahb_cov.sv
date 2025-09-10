class ahb_cov extends uvm_subscriber#(ahb_tx);
`uvm_component_utils(ahb_cov)
    
    ahb_tx tx;
    // uvm_analysis_import#(ahb_tx) ap_import;   // already declared in uvm_subscriber class
    event ahb_e;

    covergroup ahb_cg@(ahb_e);
    
        coverpoint tx.wr_rd;

    endgroup

   function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
        ahb_cg = new();     // Can also be done in build phase if you wish to use `NEW_COMP
   endfunction
   
    function void build_phase(uvm_phase phase);
        ap_import = new("ap_import", this);
    endfunction
    
    virtual function void write(T t);
        $cast(tx, t);   // Since it is parameterized we have to cast the built in handle to out tx handle
        ahb_cg.sample();
        `uvm_info("AHB_COV", $sformatf("Coverage sampeld for wr_rd=%0d", tx.wr_rd), UVM_HIGH);

    endfunction

   task run_phase(uvm_phase phase);
            
   endtask

endclass
