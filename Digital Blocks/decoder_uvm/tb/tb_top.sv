/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

`include "interface.sv"
`include "dec_pkg.sv"
`include "assertion.sv"

module tb_top;
  import uvm_pkg::*;
  import dec_pkg::*; 

  dec_if dif(); 

  dec_2to4 dut(
    .sel (dif.sel),
    .en(dif.en),
    .y(dif.y)
  );
 

 
  initial begin
   
    uvm_config_db#(virtual dec_if)::set(null, "uvm_test_top.*", "vif", dif);

   
    run_test("dec_test");
  end

 
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,tb_top);
  end

endmodule
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
