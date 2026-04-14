`include "interface.sv"
`include "fsm_pkg.sv"

`include "assertion.sv"

module tb_top;
  import uvm_pkg::*;
  import fsm_pkg::*;

  // Clock and Reset Signals
  logic clk;
  
  // 1. Clock Generation
  initial begin
   clk = 0;
    forever #(5.0) clk = ~clk;
  end

  fsm_if fif(clk); 
  
  fsm_moore dut (
    .clk(fif.clk),
    .rst_n(fif.rst_n),
    .bit_in(fif.bit_in),
    .pattern_found(fif.pattern_found)
  );
  
 
    assign fif.current_state = dut.current_state;
  
  initial begin
   
    uvm_config_db#(virtual fsm_if)::set(null, "uvm_test_top.*", "vif", fif);

  
    run_test("fsm_test");
  end

  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,tb_top);
  end

endmodule