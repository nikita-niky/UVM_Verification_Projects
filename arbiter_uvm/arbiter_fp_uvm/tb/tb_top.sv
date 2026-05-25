/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

`include "interface.sv"
`include "arbiter_pkg.sv"
`include "assertion.sv"

module tb_top;
  import uvm_pkg::*;
  import arbiter_pkg::*;

  logic clk;


  initial begin
   clk = 0;
    forever #(5.0) clk = ~clk;
  end

 
 
  arbiter_if aif(clk); //iinterface

  fixed_arbiter dut(
    .clk(aif.clk),
    .rst_n(aif.rst_n),
    .req(aif.req),
    .gnt(aif.gnt)
  );

 
  initial begin
    
    uvm_config_db#(virtual arbiter_if)::set(null, "uvm_test_top.*", "vif", aif);

    // Run the test
    run_test("arbiter_test");
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
