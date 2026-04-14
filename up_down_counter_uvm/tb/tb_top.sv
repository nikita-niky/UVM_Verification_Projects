`include "interface.sv"
`include "counter_pkg.sv"
`include "assertion.sv"

module tb_top;
  import uvm_pkg::*;
  import counter_pkg::*; 

  // Clock and Reset Signals
  logic clk;


  // 1. Clock Generation
  initial begin
   clk = 0;
    forever #(5.0) clk = ~clk;
  end

 
  // 3. Interface Instance
  counter_if cif(clk);

  // 4. DUT (Design Under Test) Instance
  counter dut (
    .clk(cif.clk),
    .rst(cif.rst),
    .load(cif.load),
    .up_down(cif.up_down),
    .count_in(cif.count_in),
    .count(cif.count),
    .max_tick(cif.max_tick),
    .min_tick(cif.min_tick)
    
  );

  // 5. Start UVM
  initial begin
    // Set the virtual interface in the Config DB
    uvm_config_db#(virtual counter_if)::set(null, "*", "vif", cif);

    // Run the test
    run_test("counter_test");
  end

  // Waveform dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,tb_top);
  end

endmodule