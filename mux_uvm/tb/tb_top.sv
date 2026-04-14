`include "interface.sv"
`include "mux_pkg.sv"
`include "assertion.sv"

module top;
	import uvm_pkg::*;
    import mux_pkg::*;
  
    logic clk;
  
    initial begin 
      clk = 0; 
      forever #5 clk = ~clk;
    end

  
    mux_if mif(clk); 


    mux_4to1 dut (
        .clk(mif.clk),
        .d(mif.d),
        .sel(mif.sel),
        .y(mif.y)
    );

    initial begin
        
        uvm_config_db#(virtual mux_if.DRV)::set(null, "uvm_test_top.env.agent.drv", "vif", mif.DRV);
      
        uvm_config_db#(virtual mux_if.MON)::set(null, "uvm_test_top.env.agent.mon", "vif", mif.MON);
      
        run_test("mux_test");
    end
endmodule