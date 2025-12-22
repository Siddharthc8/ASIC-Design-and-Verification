class axi_cov extends uvm_subscriber#(axi_tx);
`uvm_component_utils(axi_cov);

// `NEW_COMP       // Don't do we need to declare covergroup
// THe analysis port is by default present in subscriber class so don't have to declare it, just connect in M_AGENT
axi_tx tx;

covergroup axi_cg;
    ADDR_CP : coverpoint tx.addr {
        option.auto_bin_max = 8;
    }

    WR_RD_CP : coverpoint tx.wr_rd {
        bins WR = {1'b1};
        bins RD = {1'b0};
    }

    BURST_LEN_CP : coverpoint tx.burst_len {
        option.auto_bin_max = 16;
    }

    ID_CP : coverpoint tx.tx_id {
        option.auto_bin_max = 16;
    }

    BURST_TYPE_CP : coverpoint tx.burst_type {
        bins FIXED            =   {2'b00};
        bins INCR             =   {2'b01};
        bins WRAP             =   {2'b10};
        bins RSVD_BURST_TYPE  =   default;  // note this does not count towards coverage
    }

    BURST_SIZE_CP : coverpoint tx.burst_size {
        // bins SIZE_1B          =   {3'b000};
        // bins SIZE_2B          =   {3'b001};
        bins SIZE_4B          =   {3'b010};
        // bins SIZE_8B          =   {3'b011};
        // bins SIZE_16B         =   {3'b100};
        // bins SIZE_32B         =   {3'b101};  
        // bins SIZE_64B         =   {3'b110};
        // bins SIZE_128B        =   {3'b111};
        bins IGNORE           =   default;  // (OR)     
        ignore_bins IGNORED   =   {[0:1], [3:7]};  
    }

    LOCK_CP : coverpoint tx.lock {
        bins NORMAL           =   {2'b00};
        bins EXCL             =   {2'b01};
        bins LOCKED           =   {2'b10};
        bins RSVD_LOCK        =   default;  // note this does not count towards coverage
    }

    RESP_CP : coverpoint tx.respQ[0] {
        bins OKAY             =   {2'b00}; 
        bins ECOKAY           =   {2'b01};
        bins SLVERR           =   {2'b10};
        bins DECERR           =   {2'b11};
    }

    RESP_WR_RD : cross WR_RD_CP, RESP_CP;
    ADDR_WR_RD : cross WR_RD_CP, ADDR_CP;

endgroup


function new(string name = "", uvm_component parent = null);
    super.new(name, parent);

    axi_cg = new();

endfunction

function void write(axi_tx t);

    tx = new t;
    axi_cg.sample();

endfunction

// Extra from claude to print coverage in EDA only
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_type_name(), 
                  $sformatf("\n========================================\n COVERAGE REPORT\n========================================\n Total Coverage = %.2f%%\n========================================", 
                  axi_cg.get_coverage()), 
                  UVM_LOW)
    endfunction

endclass


/* TO DO:
    addr
    wr_rd
    burst_len
    burst_size
    burst_type
    prot
    cache
    lock
    id
    strb
    resp
    back to back writes
    write and read to same location
    fsm if present


  CROSS
    addr , wr_rd
    burst_len, burst_tpe


    

*/