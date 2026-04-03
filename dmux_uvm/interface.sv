interface demux_if(input logic clk);
  logic rst_n;
  logic [31:0] d;
  logic [1:0] sel;
  logic [31:0] y [0:3];
   
  clocking cb @(posedge clk);
    default input #1ns output #1ns;
   
  endclocking

    
  modport DRV (clocking cb, input clk,y,output d, sel, rst_n);
    modport MON (clocking cb, input clk,d, sel, y, rst_n);
  
endinterface