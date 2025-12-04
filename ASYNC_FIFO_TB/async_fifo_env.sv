class async_fifo_env extends uvm_env;
`uvm_component_utils(async_fifo_env)

`NEW_COMP

// There are two interfaces so we need two agents

write_agent write_agent_i;
read_agent read_agent_i;
fifo_sbd sbd;

function void build_phase(uvm_phase phase);
super.build_phase(phase);
    write_agent_i = write_agent::type_id::create("write_agent_i", this);
    read_agent_i = read_agent::type_id::create("read_agent_i", this);
    sbd = fifo_sbd::type_id::create("sbd", this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    write_agent_i.mon.ap_port.connect(sbd.imp_write);
    read_agent_i.mon.ap_port.connect(sbd.imp_read);

endfunction

endclass