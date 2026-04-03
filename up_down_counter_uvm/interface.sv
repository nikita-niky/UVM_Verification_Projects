interface counter_if(input logic clk);
  logic rst;
  logic load;
  logic up_down;
  logic [3:0] count_in;
  
  logic [3:0] count;
  logic max_tick;
  logic min_tick;
  
  clocking drv_cb @(posedge clk);
    default input #2ns output #2ns;
    output load, up_down , count_in,rst;
    input count;
  endclocking
  
  clocking mon_cb @(posedge clk);
    default input #1ns output #1ns;
    input load, up_down,count_in,count,max_tick ,min_tick,rst;
  endclocking
  
    modport DRV (clocking drv_cb, input clk );
    modport MON (clocking mon_cb, input clk);
    
  
 
endinterface