interface axi_intf(input bit aclk, input bit arst);
    //WRITE ADDR BUS
    logic  [3:0]             awid;
    logic  [`ADDR_BUS_WIDTH-1:0]            awaddr;
    logic  [3:0]             awlen;
    logic  [2:0]             awsize;
    logic  [1:0]             awburst;
    logic  [1:0]             awlock;
    logic  [3:0]             awcache;
    logic  [2:0]             awprot;
    logic                    awvalid;
    logic                    awready;
    
    //WRITE DATA BUS
    logic  [3:0]             wid;
    logic  [`DATA_BUS_WIDTH-1:0]            wdata;
    logic  [`DATA_BUS_WIDTH/8-1:0]             wstrb;
    logic                    wlast;
    logic                    wvalid;
    logic                    wready;
    
    //WRITE RESPONSE BUS
    logic  [3:0]             bid;
    logic  [1:0]             bresp;
    logic                    bvalid;
    logic                    bready;
    
    //READ ADDRESS BUS
    logic  [3:0]             arid;
    logic  [`ADDR_BUS_WIDTH-1:0]            araddr;
    logic  [3:0]             arlen;
    logic  [2:0]             arsize;
    logic  [1:0]             arburst;
    logic  [1:0]             arlock;
    logic  [3:0]             arcache;
    logic  [2:0]             arprot;
    logic                    arvalid;
    logic                    arready;
    
    //READ DATA BUS
    logic  [3:0]             rid;
    logic  [`DATA_BUS_WIDTH-1:0]            rdata;
    logic                    rlast;
    logic                    rvalid;
    logic                    rready;
    logic  [1:0]             rresp;


    // Clocking Block for RESPONDER
    clocking slave_cb @(posedge aclk);

    default input #0 output #1;

    //--> Write Address Channel:-
    input  awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot, awvalid;
    output awready;

    //--> Write Data Channel:-
    input  wid, wdata, wstrb, wlast, wvalid;
    output wready;

    //--> Write Respose Channel:-
    output  bid, bresp, bvalid;
    input bready;

    //--> Read Address Channel:-
    input  arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot, arvalid;
    output arready;
    
    //--> Read Data Channel:-
    output  rid, rdata, rresp, rlast, rvalid;
    input rready;

    endclocking

endinterface