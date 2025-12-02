class driver extends uvm_driver #(transaction);
`uvm_component_utils(driver)

virtual axi_if.tb vif;
int write_data_count;
function new(string name="driver",uvm_component parent);
super.new(name,parent);
endfunction

extern virtual function void connect_phase(uvm_phase phase);
extern virtual task run_phase(uvm_phase phase);
extern virtual task reset();
extern virtual task drive(transaction  tr);
extern virtual task write_address(transaction  tr);
extern virtual task write_data(transaction  tr);
extern virtual task write_response(transaction  tr);
extern virtual task read_address(transaction  tr);
extern virtual task read_data(transaction  tr);

endclass 

 function void driver :: connect_phase(uvm_phase phase);
 super.connect_phase(phase);
   void'(uvm_config_db #(virtual axi_if.tb) :: get (this,"","drvr_if",vif));
 if(vif==null)
 `uvm_fatal("VIF_ERR","Virtual interface in driver is NULL");
 endfunction
 
 task driver:: run_phase(uvm_phase phase);
  forever begin
	 seq_item_port.get_next_item(req);
    if(req.kind ===RESET || req.kind ==STIMULUS)
    `uvm_info("GET_PKT",$sformatf("Driver received %0s transaction from TLM port",req.kind.name()),UVM_MEDIUM);
    if(req.kind==RESET) reset();
    else if(req.kind==STIMULUS) drive(req); 
    seq_item_port.item_done();
	`uvm_info("GET_PKT",$sformatf("Driver transaction done"),UVM_MEDIUM);
end
endtask

task driver ::reset ();
    `uvm_info("Reset_PKT","Applying Reset transction into DUT",UVM_MEDIUM);
       vif.cb.awvalid    <=    0;
      vif.cb.wvalid     <=    0;
      vif.cb.bready     <=    0;
      vif.cb.arvalid    <=    0;
      vif.cb.rready     <=    0;
      vif.cb.reset     <=    1;
      repeat(2) @(vif.cb);
      vif.cb.reset     <=    0;
    `uvm_info("Reset_PKT"," Reset transaction done",UVM_MEDIUM);
endtask

task driver ::drive(transaction tr);
      fork 
        begin
            write_address(tr);
            write_data(tr);
            write_response(tr);
        end
        begin
            read_address(tr);
            read_data(tr);
        end
      join_any

endtask

 task driver::write_address(transaction tr);
      `uvm_info("Driver-write",$sformatf("WRITE ADDRESS BUS started with addr=%0d",tr.awaddr),UVM_MEDIUM);
      @( vif.cb);
      vif.cb.awid       <=     tr.awid;
      vif.cb.awaddr     <=     tr.awaddr;
      vif.cb.awlen      <=     tr.awlen;
      vif.cb.awsize     <=     tr.awsize;
      vif.cb.awburst    <=     tr.awburst;
      vif.cb.awlock     <=     tr.awlock;
      vif.cb.awcache    <=     tr.awcache;
      vif.cb.awprot     <=     tr.awprot;
      vif.cb.awvalid    <=     1;
       wait(vif.cb.awready==1);
      @(vif.cb);
      vif.cb.awid       <=     0;
      vif.cb.awaddr     <=     0;
      vif.cb.awlen      <=     0;
      vif.cb.awsize     <=     0;
      vif.cb.awburst    <=     0;
      vif.cb.awlock     <=     0;
      vif.cb.awcache    <=     0;
      vif.cb.awprot     <=     0;
      vif.cb.awvalid    <=     0;
      `uvm_info("Driver-write",$sformatf("WRITE ADDRESS BUS completed with addr=%0d",tr.awaddr),UVM_MEDIUM);
   endtask


   task driver:: write_data(transaction tr);
         write_data_count = 0;
         `uvm_info("Driver-write",$sformatf("WRITE DATA BUS started with AWBURST=%0d",tr.awburst),UVM_MEDIUM);
         repeat(tr.awlen+1) begin
          @(vif.cb);
          vif.cb.wdata      <=     $urandom;
          vif.cb.wvalid     <=     1;
          vif.cb.wstrb <= tr.wstrb;

          if(write_data_count==tr.awlen) vif.cb.wlast <=1;
          else  vif.cb.wlast <= 0;

          wait(vif.cb.wready==1);
          write_data_count++;
          @(vif.cb);
          vif.cb.wvalid <= 0;
         end

         vif.cb.wdata <=0;

         `uvm_info("Driver-write",$sformatf("WRITE DATA BUS completed with AWBURST=%0d",tr.awburst),UVM_MEDIUM);

   endtask

 task driver::write_response(transaction tr);
      `uvm_info("Driver-write",$sformatf("WRITE RESPONSE BUS started "),UVM_MEDIUM);
     vif.cb.bready     <= 1;
     wait(vif.cb.bvalid==1);
     `uvm_info("Driver-write",$sformatf("WRITE RESPONSE BUS ended "),UVM_MEDIUM);
   endtask

     task driver::read_address(transaction tr);
    `uvm_info("Driver-read",$sformatf("READ ADDRESS BUS started with addr=%0d",tr.araddr),UVM_MEDIUM);

      vif.cb.arid       <=     tr.arid;
      vif.cb.araddr     <=     tr.araddr;
      vif.cb.arlen      <=     tr.arlen;
      vif.cb.arsize     <=     tr.arsize;
      vif.cb.arburst    <=     tr.arburst;
      vif.cb.arlock     <=     tr.arlock;
      vif.cb.arcache    <=     tr.arcache;
      vif.cb.arprot     <=     tr.arprot;
      vif.cb.arvalid    <=     1;
      wait(vif.cb.arready==1) ;
      @(vif.cb);
      vif.cb.arid       <=     0;
      vif.cb.araddr     <=     0;
      vif.cb.arvalid    <=     0;
    `uvm_info("Driver-read",$sformatf("READ ADDRESS BUS completed with addr=%0d",tr.araddr),UVM_MEDIUM);
   endtask

     task driver::read_data(transaction tr);
      repeat(tr.arlen+1) begin
          @(vif.cb)
          `uvm_info("Driver-read",$sformatf("READ DATA BUS started with AWBURST=%0d",tr.awburst),UVM_MEDIUM);
         wait(vif.cb.rvalid==1);
         vif.cb.rready     <= 1;
         @(vif.cb);
         vif.cb.rready     <=0;
      end
   endtask
   
