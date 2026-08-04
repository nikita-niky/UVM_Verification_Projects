/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

`include "interface.sv"
`include "fsm_pkg.sv"
`include "assertion.sv"

module tb_top;
  import uvm_pkg::*;
  import fsm_pkg::*;

  // Clock and Reset Signals
  logic clk;

 
  initial begin
   clk = 0;
    forever #(5.0) clk = ~clk;
  end

  fsm_if fif(clk); 
  
  fsm_mealy dut (
    .clk(fif.clk),
    .rst_n(fif.rst_n),
    .bit_in(fif.bit_in),
    .pattern_found(fif.pattern_found)
  );
  
 
    assign fif.current_state = dut.current_state;
  
  initial begin
    // Set the virtual interface in the Config DB
    uvm_config_db#(virtual fsm_if)::set(null, "uvm_test_top.*", "vif", fif);

    // Run the test
    run_test("fsm_test");
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
