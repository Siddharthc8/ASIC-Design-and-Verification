// Since we are creating UVCs the M_UVC(m_agent) and the S_UVC(s_agent) will be a part of the ENV

class axi_env extends uvm_env;
`uvm_component_utils(axi_env)

`NEW_COMP

axi_master_agent m_agent;
axi_slave_agent s_agent;
// axi_sbd sbd;

function void build_phase(uvm_phase phase);
super.build_phase(phase);
    m_agent = axi_master_agent::type_id::create("m_agent", this);
    s_agent = axi_slave_agent::type_id::create("s_agent", this);
    // sbd = axi_sbd::type_id::create("sbd", this);
endfunction

// function void connect_phase(uvm_phase phase);
// super.build_phase(phase);
//     m_agent.mon.ap_port.connect(sbd.imp_master);
//     s_agent.mon.ap_port.connect(sbd.imp_slave);
// endfunction

endclass