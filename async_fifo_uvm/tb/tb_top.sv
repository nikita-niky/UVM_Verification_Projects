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

  // Clock Signals
  logic wclk, rclk;
 

  // 1. Clock Generation
  initial begin
   wclk = 0; // Write Clock: 100MHz (Period = 10ns)
    forever #(5.0) wclk = ~wclk;
  end
  
  initial begin
   rclk = 0;  // Read Clock: 40MHz (Period = 25ns)
    forever #(12.5) rclk = ~rclk;
  end

  // 2. Reset Generation
  //initial begin
   // rst_n = 0;
   // #20 rst_n = 1;
  //end

  // 3. Interface Instance
  fifo_if fif(wclk,rclk); 

  // 4. DUT (Design Under Test) Instance
  async_fifo dut (
    .wclk(fif.wclk),
    .rclk(fif.rclk),
    .wrst_n(fif.wrst_n),
    .rrst_n(fif.rrst_n),
    .winc(fif.winc),
    .rinc(fif.rinc),
    .wdata(fif.wdata),
    .rdata(fif.rdata),
    .wfull(fif.wfull),
    .rempty(fif.rempty)    
  );

  // 5. Start UVM
  initial begin
    // Set the virtual interface in the Config DB
    uvm_config_db#(virtual fifo_if)::set(null, "*", "vif", fif);

    
    // Set simulation timeout 
    // uvm_top.set_timeout(1ms);
    
    // Run the test for individual test check
//     run_test("fifo_directed_test");

//     run_test("fifo_random_test");
    
//     run_test("fifo_ovfl_test");
//     run_test("fifo_udfl_test");
    
//     run_test("fifo_stress_test");
    
//     run_test("fifo_reset_op_test");
    
    run_test(); // to run all one after other 
    
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
