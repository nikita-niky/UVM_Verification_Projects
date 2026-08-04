/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

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
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
