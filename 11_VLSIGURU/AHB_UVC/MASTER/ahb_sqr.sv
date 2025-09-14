// typedef uvm_sequencer#(ahb_tx) ahb_sqr;
class ahb_sqr extends uvm_sequencer#(ahb_tx);
    `uvm_component_utils(ahb_sqr)
    
    function new(string name = "ahb_sqr", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass
