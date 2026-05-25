/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

`include "interface.sv"
`include "alu_pkg.sv"
`include "assertion.sv"

module tb_top;
  import uvm_pkg::*;
  import alu_pkg::*; 


  logic clk;


  //1. Clock Generation
  initial begin
   clk = 0;

    
  end
  always #5 clk = ~clk;


  alu_if aif(clk); 
  
  alu dut(
    .clk(aif.clk),
    .rst(aif.rst),
    .a(aif.a),
    .b(aif.b),
    .op(aif.op),
    .res(aif.res),
    .carry(aif.carry),
    .zero(aif.zero),
    .neg(aif.neg),
    .ovfl(aif.ovfl)
  );

  // 5. Start UVM
  initial begin
  uvm_config_db#(virtual alu_if)::set(null, "*", "vif", aif);

    // Run the test
    run_test("alu_test");
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
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
