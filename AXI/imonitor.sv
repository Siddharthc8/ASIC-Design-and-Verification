class iMonitor extends uvm_monitor;
`uvm_component_utils(iMonitor)

virtual axi_if.tb_mon vif;
uvm_analysis_port #(transaction) analysis_port;
transaction trans;

function new(string name="iMonitor",uvm_component parent);
	super.new(name,parent);
endfunction

extern virtual function void build_phase(uvm_phase phase);
extern virtual function void connect_phase(uvm_phase phase);
extern virtual task run_phase(uvm_phase phase);

endclass

function void iMonitor ::build_phase(uvm_phase phase);
	super.build_phase(phase);
	analysis_port=new("analysis_port",this);
endfunction

function void iMonitor ::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
  if(!uvm_config_db #(virtual axi_if.tb_mon) :: get(this,"","iMon_if",vif)) begin
		`uvm_fatal(get_type_name(),"iMonitor DUT interface not set");
	end
endfunction

task iMonitor ::run_phase(uvm_phase phase);
    super.run_phase (phase);
    
    forever begin
     @(vif.cb_mon);  
 
    if(vif.cb_mon.reset==0) begin
        trans=transaction::type_id::create("trans",this);

  //address write
       wait(vif.cb_mon.awvalid==1 && vif.cb_mon.awready==1);
       trans.awlen     = vif.cb_mon.awlen;
       trans.awaddr_arr= new[trans.awlen+1];
       trans.wdata_arr    = new[trans.awlen+1];
       trans.awaddr_arr[0]=vif.cb_mon.awaddr;
       
//write data
        for(int i=0;i<=trans.awlen;i++) begin
            wait(vif.cb_mon.wvalid==1 && vif.cb_mon.wready==1);
            if(i)  trans.awaddr_arr[i]=trans.awaddr_arr[i-1]+4;//you will tell trans.awaddr[i]=vif.cb.next_addr
            trans.wstrb=vif.cb_mon.wstrb;
            trans.wdata_arr[i]=vif.cb_mon.wdata;
            @(vif.cb_mon);
        end

   //write resp     
        wait(vif.cb_mon.bvalid == 1 && vif.cb_mon.bready==1);
           trans.bresp=vif.cb_mon.bresp;
        analysis_port.write(trans);
          `uvm_info("iMon",$sformatf( " WRITE TRANSFER with burst len=%0d addr : %0p data : %0p completed",trans.awlen +1 ,trans.awaddr_arr, trans.wdata_arr),UVM_MEDIUM);
 
    end
 end
endtask


    
