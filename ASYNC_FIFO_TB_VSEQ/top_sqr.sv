class top_sqr extends uvm_sequencer;
`uvm_component_utils(top_sqr)

write_sqr write_sqr_i;   // We don't create objets because we map these to ones in the agent in environment
read_sqr read_sqr_i;

`NEW_COMP

endclass