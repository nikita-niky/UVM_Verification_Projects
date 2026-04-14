interface mux_if(input logic clk);
  logic [31:0] d [3:0];
  logic [1:0] sel;
  logic [31:0] y;
  
   clocking cb @(posedge clk);
    default input #1ns output #1ns;
  endclocking

  modport DRV (clocking cb, input clk,y,output d,sel);
  modport MON (clocking cb, input clk,d,sel,y);
  
endinterface