/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

`include "interface.sv"
`include "arb_pkg.sv"
`include "assertion.sv"

module tb_top;
  import uvm_pkg::*;
  import arb_pkg::*; 

  // Clock and Reset Signals
  logic clk;
  

  // 1. Clock Generation
  initial begin
   clk = 0;
    forever #(5.0) clk = ~clk;
  end

  
  // 2. Interface Instance
  arb_if aif(clk); 

  // 3. DUT (Design Under Test) Instance
  round_robin_arbiter dut(
    .clk(aif.clk),
    .rst_n(aif.rst_n),
    .req(aif.req),
    .gnt(aif.gnt)
  );

  // 4. Start UVM
  initial begin
    // Set the virtual interface in the Config DB
    uvm_config_db#(virtual arb_if)::set(null, "uvm_test_top.*", "vif", aif);

    // Run the test
    run_test("arb_test");
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
