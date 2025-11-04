class incr_sequence extends uvm_sequence #(transaction);
    `uvm_object_utils(incr_sequence)

  function new(string name = "incr_sequence");
    super.new(name);
    set_automatic_phase_objection(1);       // Automatic phase raise objection UVM 1.2
  endfunction


virtual task body();
  bit [31:0] count;
  REQ rand_pkt;                                                         // REQ is used for reusability 
  rand_pkt=transaction::type_id::create("rand_pkt", get_full_name());   // Check if the second arg is valid

  repeat(15) begin
      `uvm_create(req);
      rand_pkt.unaligned_addr.constraint_mode(1);
      rand_pkt.aligned_addr.constraint_mode(0);
      rand_pkt.randomize() with {awburst==1;awsize==3'b010;awlen==9;wstrb==4'b1111;awaddr inside {[100:200]};};
      req.copy(rand_pkt);
      req.kind=STIMULUS;
      start_item(req);
      finish_item(req);
      `uvm_info("INCR WRITE",$sformatf("INCR len sequence : Write transfer Done with burst length=%0d ,start ADDR=%0d",req.awlen+1,req.awaddr),UVM_MEDIUM);
  end
  
endtask

endclass
