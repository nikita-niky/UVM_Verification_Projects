/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

`include "interface.sv"
`include "fifo_pkg.sv"
`include "assertion.sv"

module tb_top;
  import uvm_pkg::*;
  import fifo_pkg::*; 

  // Clock and Reset Signals
  logic clk;
  logic rst_n;

  // 1. Clock Generation
  initial begin
    clk = 0;
    forever #(5.0) clk = ~clk;
  end

  // 2. Reset Generation
//   initial begin
//     rst_n = 0;
//     #20;
//     rst_n = 1;
//   end

  // 3. Interface Instance
  fifo_if fif(clk); // if using clock include in bracket

  // 4. DUT (Design Under Test) Instance
  sync_fifo dut (
    .clk(fif.clk),
    .rst_n(fif.rst_n),
    .wr_en(fif.wr_en),
    .wdata(fif.wdata),
    .rd_en(fif.rd_en),
    .rdata(fif.rdata),
    .full(fif.full),
    .empty(fif.empty)
  );

  // 5. Start UVM
  initial begin
    // Set the virtual interface in the Config DB
    uvm_config_db#(virtual fifo_if)::set(null, "*", "vif", fif);

    // Run the test
    run_test("fifo_test");
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
