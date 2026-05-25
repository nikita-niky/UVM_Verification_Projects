/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

interface fifo_if(input logic clk);
  
  logic rst_n;
  logic wr_en;
  logic [7:0] wdata;
  
  logic rd_en;
  logic [7:0] rdata;
  
  logic full;
  logic empty;
  
  clocking drv_cb @(posedge clk);
    default input #1ns output #1ns;
    input rdata, full, empty;
    output wdata, wr_en, rd_en, rst_n;
  endclocking
  
  clocking mon_cb @(posedge clk);
    default input #1ns output #1ns;
    input rdata, full, empty,wdata, wr_en, rd_en, rst_n;
  endclocking
  
  modport DRV(clocking drv_cb, input clk);
  modport MON(clocking mon_cb, input clk);
      
 

endinterface
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
