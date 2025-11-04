`ifndef AXI_TRANSACTION
`define AXI_TRANSACTION
typedef enum {UNKNOWN,RESET,STIMULUS} pkt_kind;

class transaction extends uvm_sequence_item;

   
    bit reset;
    rand bit [7:0]id;
    pkt_kind kind;
    bit [31:0] awaddr_arr[];
    bit [31:0] araddr_arr[];
    bit [31:0] wdata_arr[];
    bit [31:0] rdata_arr[];
    bit  rresp_arr[];

    //WRITE ADDRESS BUS
    rand bit  [7:0]        awid;
    rand bit  [15:0]       awaddr;
    rand bit  [7:0]        awlen;
    rand bit  [2:0]        awsize;
    rand bit  [1:0]        awburst;
    bit                    awlock;
    bit  [3:0]             awcache;
    bit  [2:0]             awprot;
    bit                    awvalid;
    bit                    awready;
    
    //WRITE DATA BUS
    rand bit  [31:0]       wdata;
    rand  bit  [3:0]       wstrb;
    bit                    wlast;
    bit                    wvalid;
    bit                    wready;
    
    //WRITE RESPONSE BUS
    rand bit  [7:0]        bid;
    bit  [1:0]             bresp;
    bit                    bvalid;
    bit                    bready;
    
    //READ ADDRESS BUS
    rand bit  [7:0]        arid;
    rand bit  [15:0]       araddr;
    rand bit  [7:0]        arlen;
    rand bit  [2:0]        arsize;
    rand bit  [1:0]        arburst;
    bit                    arlock;
    bit  [3:0]             arcache;
    bit  [2:0]             arprot;
    bit                    arvalid;
    bit                    arready;
    
    //READ DATA BUS
   rand  bit  [7:0]        rid;
    bit  [31:0]            rdata;
    bit  [1:0]             rresp;
    bit                    rlast;
    bit                    rvalid;
    bit                    rready;

    constraint id_c{id  inside {[1:15]}; awid == id; bid == id; arid == id; rid == id;}

    constraint strobe_c{soft wstrb==4'b1111;}
    constraint size_c{ awsize==2 && arsize==2;}
    constraint burst_c{awburst==arburst;}
    constraint len_c{awlen==arlen;}
    constraint addr_c{awaddr inside {[100:200]};araddr ==awaddr;}
    constraint unaligned_addr{awaddr%4!=0;}
    constraint aligned_addr{awaddr%4==0;}
    
        
    `uvm_object_utils_begin(transaction)
   
   `uvm_field_int(reset,UVM_ALL_ON)
   
   //WRITE ADDRESS BUS
   `uvm_field_int(awid,UVM_ALL_ON)
   `uvm_field_int(awaddr,UVM_ALL_ON)
   `uvm_field_int(awlen,UVM_ALL_ON)
   `uvm_field_int(awsize,UVM_ALL_ON)
   `uvm_field_int(awburst,UVM_ALL_ON)
   `uvm_field_int(awlock,UVM_ALL_ON)
   `uvm_field_int(awcache,UVM_ALL_ON)
   `uvm_field_int(awprot,UVM_ALL_ON)
   `uvm_field_int(awvalid,UVM_ALL_ON)
   `uvm_field_int(awready,UVM_ALL_ON)
   `uvm_field_array_int(awaddr_arr,UVM_ALL_ON)

   //WRITE DATA BUS
   `uvm_field_int(wdata,UVM_ALL_ON)
   `uvm_field_int(wstrb,UVM_ALL_ON)
   `uvm_field_int(wlast,UVM_ALL_ON)
   `uvm_field_int(wvalid,UVM_ALL_ON)
   `uvm_field_int(wready,UVM_ALL_ON)
   `uvm_field_array_int(wdata_arr,UVM_ALL_ON)


   //WRITE RESPONSE BUS
   `uvm_field_int(bid,UVM_ALL_ON)
   `uvm_field_int(bresp,UVM_ALL_ON)
   `uvm_field_int(bvalid,UVM_ALL_ON)
   `uvm_field_int(bready,UVM_ALL_ON)

   //READ ADDRESS BUS
   `uvm_field_int(arid,UVM_ALL_ON)
   `uvm_field_int(araddr,UVM_ALL_ON)
   `uvm_field_int(arlen,UVM_ALL_ON)
   `uvm_field_int(arsize,UVM_ALL_ON)
   `uvm_field_int(arburst,UVM_ALL_ON)
   `uvm_field_int(arlock,UVM_ALL_ON)
   `uvm_field_int(arcache,UVM_ALL_ON)
   `uvm_field_int(arprot,UVM_ALL_ON)
   `uvm_field_int(arvalid,UVM_ALL_ON)
   `uvm_field_int(arready,UVM_ALL_ON)
   `uvm_field_array_int(araddr_arr,UVM_ALL_ON)
  


   //READ DATA BUS
   `uvm_field_int(rid,UVM_ALL_ON)
  `uvm_field_int(rdata,UVM_ALL_ON)
   `uvm_field_int(rresp,UVM_ALL_ON)
   `uvm_field_int(rlast,UVM_ALL_ON)
   `uvm_field_int(rvalid,UVM_ALL_ON)
   `uvm_field_int(rready,UVM_ALL_ON)
    `uvm_field_array_int(rdata_arr,UVM_ALL_ON)
   `uvm_field_array_int(rresp_arr,UVM_ALL_ON)
   
   `uvm_object_utils_end

   function new(string name="transaction");
      super.new(name);
   endfunction

endclass




`endif


