interface fsm_if(input logic clk);
  
  logic rst_n;
  logic bit_in;
  logic pattern_found;
  
  logic [2:0] current_state;  /// internally defined
  
 
  
  clocking drv_cb @(posedge clk);
    default input #1ns output #1ns;
    input pattern_found;
    output bit_in,rst_n;
  endclocking
  
  clocking mon_cb @(posedge clk);
    default input #1ns output #1ns;
    input bit_in, pattern_found, current_state,rst_n;
  endclocking
  
  modport DRV (clocking drv_cb, input clk);
  modport MON (clocking mon_cb, input clk);
  

endinterface