interface sr_if(input logic clk);
  logic rst;
  logic [1:0] mode;
  logic sin_left;
  logic sin_right;
  logic [3:0] d_in;
  logic [3:0] q_out;


  clocking drv_cb @(posedge clk);
    default input #1ns output #1ns;
    output rst,mode,sin_left,sin_right,d_in;
    input q_out;
  endclocking

  clocking mon_cb @(posedge clk);
    default input #1ns output #1ns;
    input rst,mode,sin_left,sin_right, d_in, q_out;
  endclocking

  modport DRV (clocking drv_cb, input clk);
  modport MON (clocking mon_cb, input clk);
    
endinterface