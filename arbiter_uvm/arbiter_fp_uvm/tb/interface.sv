interface arbiter_if(input logic clk);
  logic rst_n;
  logic [3:0] req;
  logic [3:0] gnt;
  
  clocking drv_cb @(posedge clk);
    default input #1ns output #1ns;
    input gnt;
    output rst_n,req;
  endclocking
  
  clocking mon_cb @(posedge clk);
    default input #1ns output #1ns;
    input rst_n, req, gnt;
  endclocking
  
  modport DRV (clocking drv_cb, input clk);
  modport MON (clocking mon_cb, input clk);

endinterface