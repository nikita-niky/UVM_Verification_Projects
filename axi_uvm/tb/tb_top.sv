/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

`include "interface.sv"
`include "axi_pkg.sv"
`include "assertion.sv"

module tb_top;
  import uvm_pkg::*;
  import axi_pkg::*; 

  // Clock and Reset Signals
  logic clk;
  logic rst;

  // 1. Clock Generation
  initial begin
   clk = 0;
    forever #(5.0) clk = ~clk;
  end

  // 2. Reset Generation
  initial begin
   rst = 1;
   #20 ;
    rst = 0;
  end

  // 3. Interface Instance
  axi_if aif(clk,rst); 

  // 4. DUT (Design Under Test) Instance
  axi_slave dut(
    .clk(aif.clk),
    .rst(aif.rst),
    
    .awid(aif.awid),
    .awaddr(aif.awaddr),
    .awlen(aif.awlen),
    .awsize(aif.awsize),
    .awburst(aif.awburst),
    .awlock(aif.awlock),
    .awcache(aif.awcache),
    .awprot(aif.awprot),
    .awvalid(aif.awvalid),
    .awready(aif.awready),
    
    .wdata(aif.wdata),
    .wstrb(aif.wstrb),
    .wlast(aif.wlast),
    .wvalid(aif.wvalid),
    .wready(aif.wready),
    
    .bid(aif.bid),
    .bresp(aif.bresp),
    .bvalid(aif.bvalid),
    .bready(aif.bready),
    
    .arid(aif.arid),
    .araddr(aif.araddr),
    .arlen(aif.arlen),
    .arsize(aif.arsize),
    .arburst(aif.arburst),
    .arlock(aif.arlock),
    .arcache(aif.arcache),
    .arprot(aif.arprot),
    .arvalid(aif.arvalid),
    .arready(aif.arready),
    
    .rid(aif.rid),
    .rdata(aif.rdata),
    .rresp(aif.rresp),
    .rlast(aif.rlast),
    .rvalid(aif.rvalid),
    .rready(aif.rready)   
  );
 

  // 5. Start UVM
  initial begin
    // Set the virtual interface in the Config DB
    uvm_config_db#(virtual axi_if)::set(null, "*", "vif", aif);

    // Run the test
    run_test("axi_test");
  end

  // Waveform dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,tb_top);
  end

endmodule
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
