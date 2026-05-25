/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

`include "interface.sv"
`include "p_enc_pkg.sv"
`include "assertion.sv"

module tb_top;
  import uvm_pkg::*;
  import p_enc_pkg::*; 
  
  enc_if pif(); 
  p_enc dut (
    .req  (pif.req),
    .code (pif.code),
    .valid(pif.valid)
  );
  
  initial begin
   
    uvm_config_db#(virtual enc_if)::set(null, "uvm_test_top.*", "vif", pif);

    run_test("p_enc_test");
    
  end

  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,tb_top);
  end

endmodule
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
