/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

interface arb_if(input logic clk);
  logic rst_n;
  logic [3:0] req;
  logic [3:0] gnt;
  
  clocking drv_cb @(posedge clk);
    default input #1ns output #1ns;
    input gnt;
    output req, rst_n;
  endclocking
  
  clocking mon_cb @(posedge clk);
    default input #1step output #1step;
    input req, gnt, rst_n;
  endclocking
  
  modport DRV(clocking drv_cb, input clk);
  modport MON (clocking mon_cb, input clk);
  
  
  
endinterface
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
