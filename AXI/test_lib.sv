class base_test extends uvm_test;
	`uvm_component_utils(base_test)
	environment env;
  virtual axi_if avif;
	
	function new(string name="base_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
   	env=environment::type_id::create("env",this);
  
      uvm_config_db #(virtual axi_if) ::get(this,"","master_if",avif);
		if(avif==null) 
			`uvm_fatal("VIF_ERR","Virtual interface in test is NULL");
		uvm_config_db #(virtual axi_if.tb) ::set (this,"env.m_agent.drvr","drvr_if",avif.tb);
		uvm_config_db #(virtual axi_if.tb_mon) ::set (this,"env.m_agent.iMon","iMon_if",avif.tb_mon);
	uvm_config_db #(virtual axi_if.tb_mon) ::set (this,"env.s_agent.oMon","oMon_if",avif.tb_mon);

	uvm_config_db #(uvm_object_wrapper) :: set(this,"env.m_agent.seqr.reset_phase","default_sequence",reset_sequence::get_type());
//	uvm_config_db #(uvm_object_wrapper) :: set(this,"env.m_agent.seqr.main_phase","default_sequence",incr_sequence::get_type());
uvm_config_db #(uvm_object_wrapper) :: set(this,"env.m_agent.seqr.main_phase","default_sequence",fixed_sequence::get_type());
    
	endfunction
	
	
	task main_phase(uvm_phase phase);
		uvm_objection objection;
		super.main_phase(phase);
		objection=phase.get_objection();
		objection.set_drain_time(this,200);
	endtask
    

endclass
