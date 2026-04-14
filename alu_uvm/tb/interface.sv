interface alu_if(input logic clk);
  logic       rst;
  logic [3:0] a;
  logic [3:0] b;
  logic [2:0] op;
  logic [3:0] res; //result
  logic carry; //carry flag
  logic zero; //zero flag
  logic neg; //negative flag
  logic ovfl; ///overflow flag
  
  clocking drv_cb @(posedge clk);
    default input #1ns output #1ns;
    input res,carry,zero,ovfl,neg;
    output rst,a,b,op;
  endclocking
  
  clocking mon_cb @(posedge clk);
    default input #1ns output #1ns;
    input res,carry,zero,ovfl,neg,rst,a,b,op;
  endclocking
  
  modport DRV (clocking drv_cb, input clk);
    modport MON (clocking mon_cb, input clk);
  

endinterface