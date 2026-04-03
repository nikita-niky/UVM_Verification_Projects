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