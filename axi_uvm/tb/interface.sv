interface axi_if(input logic clk,input logic rst);
  
    parameter  DATA_WIDTH = 32;
    parameter  ADDR_WIDTH = 16;
    parameter  STRB_WIDTH = (DATA_WIDTH/8);
    parameter  ID_WIDTH   = 8;


  // Write Address Channel
  logic [ID_WIDTH-1:0]    awid;
  logic [ADDR_WIDTH-1:0]  awaddr;
  logic [7:0]             awlen;
  logic [2:0]             awsize;
  logic [1:0]             awburst;
  logic                   awlock;
  logic [3:0]             awcache;
  logic [2:0]             awprot;
  logic                   awvalid;
  logic                   awready;
 
  // Write Data Channel
  logic [DATA_WIDTH-1:0]  wdata;
  logic [STRB_WIDTH-1:0]  wstrb;
  logic                   wlast;
  logic                   wvalid;
  logic                   wready;

  // Write Response Channel
  logic [ID_WIDTH-1:0]    bid;
  logic [1:0]             bresp;
  logic                   bvalid;
  logic                   bready;

  // Read Address Channel
  logic [ID_WIDTH-1:0]    arid;
  logic [ADDR_WIDTH-1:0]  araddr;
  logic [7:0]             arlen;
  logic [2:0]             arsize;
  logic [1:0]             arburst;
  logic                   arlock;
  logic [3:0]             arcache;
  logic [2:0]             arprot;
  logic                   arvalid;
  logic                   arready;

  // Read Data Channel
  logic [ID_WIDTH-1:0]    rid;
  logic [DATA_WIDTH-1:0]  rdata;
  logic [1:0]             rresp;
  logic                   rlast;
  logic                   rvalid;
  logic                   rready;

  clocking drv_cb@(posedge clk);
    default input #1ns output #1ns;
    
    input awready,wready, bid,bresp, bvalid,  arready,rid, rdata, rresp, rlast,rvalid;
    
    output awid, awaddr, awlen,awsize, awburst, awlock, awcache, awprot, awvalid, wdata, wstrb, wlast, wvalid, bready, arid, araddr, arlen, arsize, arburst,arlock, arcache, arprot, arvalid, rready;
  
  endclocking

  clocking mon_cb @(posedge clk);
    default input #1ns output #1ns;
    
    input awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot, awvalid, awready, wdata, wstrb, wlast, wvalid, wready, bid, bresp, bvalid, bready, arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot, arvalid, arready, rid, rdata, rresp, rlast, rvalid, rready;
 
  endclocking

  modport DRV(clocking drv_cb, input clk,rst);
  modport MON(clocking mon_cb, input clk,rst);
  
  

endinterface