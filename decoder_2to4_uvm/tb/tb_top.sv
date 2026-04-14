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