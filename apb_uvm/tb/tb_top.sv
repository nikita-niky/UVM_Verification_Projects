`include "interface.sv"
`include "apb_pkg.sv"
`include "assertion.sv"

module tb_top;
  import uvm_pkg::*;
  import apb_pkg::*; 

  // Clock and Reset Signals
  logic clk;
  logic rst_n;

  // 1. Clock Generation
  initial begin
   clk = 0;
    forever #(5.0) clk = ~clk;
  end

//   // 2. Reset Generation
//   initial begin
//    rst_n = 0;
//    #20 rst_n = 1;
//   end

  // 3. Interface Instance
  apb_if aif(clk);

  // 4. DUT (Design Under Test) Instance
  apb_master dut(.PCLK(aif.pclk),
                 .PRESETn(aif.preset_n),
                 .transfer(aif.transfer),
                 .addr_in(aif.addr_in),
                 .data_in(aif.data_in),
                 .write_en(aif.write_en),

                 .PADDR(aif.paddr),
                 .PSEL(aif.psel),
                 .PENABLE(aif.penable),
                 .PWRITE(aif.pwrite),
                 .PWDATA(aif.pwdata),
                 .PRDATA(aif.prdata),                   
                 .PREADY(aif.pready)
                );
  
  apb_slave dut2(.PCLK(aif.pclk),
                 .PRESETn(aif.preset_n),
                 
                 .PADDR(aif.paddr),
                 .PSEL(aif.psel),
                 .PENABLE(aif.penable),
                 .PWRITE(aif.pwrite),
                 .PWDATA(aif.pwdata),
                 .PRDATA(aif.prdata),                   
                 .PREADY(aif.pready),
                 .PSLVERR(aif.pslverr)
                );
 

  // 5. Start UVM
  initial begin
    // Set the virtual interface in the Config DB
    uvm_config_db#(virtual apb_if)::set(null, "*", "vif", aif);

    // Run the test
    run_test("apb_test");

  end

  // Waveform dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,tb_top);
  end

endmodule