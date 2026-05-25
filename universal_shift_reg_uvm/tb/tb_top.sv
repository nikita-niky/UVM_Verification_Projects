/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

`include "interface.sv"
`include "univ_sr_pkg.sv"
`include "assertion.sv"

module tb_top;
  import uvm_pkg::*;
  import univ_sr_pkg::*; 

  // Clock and Reset Signals
  logic clk;


  //   1. Clock Generation
  initial begin
    clk = 1;
    forever #(5.0) clk = ~clk;
  end


  // 3. Interface Instance
  sr_if sif(clk); 

  univ_sr dut(

    .clk(sif.clk),
    .rst(sif.rst),
    .mode(sif.mode),
    .sin_left(sif.sin_left),
    .sin_right(sif.sin_right),
    .d_in(sif.d_in),
    .q_out(sif.q_out)
  );




  // 5. Start UVM
  initial begin

    uvm_config_db#(virtual sr_if)::set(null, "uvm_test_top.*", "vif", sif);

    // Run the test
    run_test("univ_sr_test");
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
