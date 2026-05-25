/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

`include "interface.sv"
`include "demux_pkg.sv"
`include "assertion.sv"

module top;
  import uvm_pkg::*;
    import mux_pkg::*;
  
    bit clk;
    bit rst_n;
  
  	always #5 clk = ~clk;
  
    initial begin
      clk = 0;
      rst_n=0;
      #5;
      rst_n =1;
      
    end

    demux_if mif(clk);
    
    demux_1to4 dut (
        .clk(mif.clk), 
        .rst_n(mif.rst_n), 
        .d(mif.d), 
        .sel(mif.sel), 
      .y(mif.y) );

    initial begin
        
        uvm_config_db#(virtual demux_if.DRV)::set(null, "uvm_test_top.*", "vif", mif.DRV);
      
        uvm_config_db#(virtual demux_if.MON)::set(null, "uvm_test_top.*", "vif", mif.MON);
      
        run_test("demux_test");
    end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,top);
  end
  
    
endmodule
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
